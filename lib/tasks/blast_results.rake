namespace :app do
namespace :blast_results do

	task :index_select => :environment do
		BlastResult.where(BlastResult.arel_table[:file_name].matches("PBSF120213_SF02%")).find_each do |b|
			b.index
		end
		Sunspot.commit
	end

	task :check_hit_rank => :environment do
		contig_name,hit_rank,count,prev_expect=nil
		BlastResult.find_each do |b|
#		BlastResult.where(BlastResult.arel_table[:id].gteq(26599950)).find_each do |b|
			if( contig_name != b.contig_name )
				hit_rank=1
				count=1
				prev_expect=nil
				contig_name = b.contig_name
			else
				count+=1
				hit_rank = count unless b.expect == prev_expect
			end
			puts "#{b.id} : #{b.file_name} : #{contig_name} : #{hit_rank}"
			b.update_attributes!(:hit_rank => hit_rank)	#	will only actually update if different
			prev_expect = b.expect
		end
		Sunspot.commit
	end

	task :import => :environment do
		puts "Start #{Time.now}"
		env_required('file')


		#	bundle exec rake app:blast_results:import file="/Volumes/cube/working/output/fallon_*/trinity_non_human_*.blastn.txt"

#
#	Before reimporting
#
#    fallon_SFPB001A/trinity_non_human_paired.blastn.txt ( 2095804 )
#
#    1 ( 536060 )				570676
#
#    Virus ( 652 )
#    Bacteria ( 45664 )
#    Primate ( 1674086 )
#
#
#    fallon_SFPB001A/trinity_non_human_single.blastn.txt ( 2860211 )
#
#    1 ( 638463 )				692941
#
#    Virus ( 892 )
#    Bacteria ( 48448 )
#    Primate ( 2277896 )
#
#
#    fallon_SFPB001B/trinity_non_human_paired.blastn.txt ( 4104187 )
#
#    1 ( 1060675 )			1158192
#
#    Virus ( 589 )
#    Bacteria ( 47245 )
#    Primate ( 3296411 )
#
#
#    fallon_SFPB001B/trinity_non_human_single.blastn.txt ( 7748919 )
#
#    1 ( 1687704 )			1886600
#
#    Virus ( 705 )
#    Bacteria ( 52965 )
#    Primate ( 6032481 )
#
#
#    fallon_SFPB001C/trinity_non_human_paired.blastn.txt ( 3541400 )
#
#    1 ( 888279 )				974072
#
#    Virus ( 597 )
#    Bacteria ( 54746 )
#    Primate ( 2853924 )
#
#
#    fallon_SFPB001C/trinity_non_human_single.blastn.txt ( 6560541 )
#
#    1 ( 1406681 )			1614595
#
#    Virus ( 1284 )
#    Bacteria ( 63240 )
#    Primate ( 5114671 )
#
#    fallon_SFPB001D/trinity_non_human_paired.blastn.txt ( 1114314 )
#
#    1 ( 243620 )				270669
#
#    Virus ( 1303 )
#    Bacteria ( 69201 )
#    Primate ( 871413 )
#
#    fallon_SFPB001D/trinity_non_human_single.blastn.txt ( 1670128 )
#
#    1 ( 322252 )				382408
#
#    Virus ( 1440 )
#    Bacteria ( 64576 )
#    Primate ( 1347066 )


		files = Dir[ ENV['file'] ]
		puts files.inspect

		files.each do |file|

			filename = file.dup

			if filename.split('/').length > 1
				#	if only one value in array, [-2] will return nil (so just use the given filename)
				filename = filename.split('/')[-2..-1].join('/')
			end

			blast_defaults = {:file_name => filename}

			blast_result = blast_defaults.dup
			line=''
			hits_found=true

			hit_rank,prev_expect,count=nil
			from_line_number = ENV['from_line_number'].to_i || 0
			line_count = 0

			(f=File.open(file,'rb')).each do |l|
				line_count += 1
				if line_count < from_line_number
					puts "line_count:#{line_count} still less than #{from_line_number}. Skipping."
					next
				#else
				#	puts "line_count:#{line_count} STILL NOT less than #{from_line_number}. Test skipping."
				#	next
				end
				line=line+l.chomp

				#	first will include all the header stuff
				if( line.match(/Query= (.*)Length=(\d+)$/) )
					blast_result=blast_defaults.dup
					#	ActiveRecord::StatementInvalid: Mysql2::Error: Data too long for column 'contig_description' 
					blast_result[:contig_description]=$1[0..254]	#	some are too long (length<=255)
					blast_result[:contig_length]=$2
					blast_result[:contig_name]=blast_result[:contig_description].split(/\s+/)[0]
					count=0
					hit_rank=1
					prev_expect=nil
					line=''
				elsif( l.match(/Query= /) )
					line=l.chomp
				elsif( line.match(/^>(.*)Length=(\d+)$/) )

					count+=1

					#	Had a REALLY long seq_name.  Need to trim this field as well.
					#>gb|BC127919.1| Homo sapiens similar to TBC1 domain family, member 2B, mRNA (cDNA 
					#clone IMAGE:40132505), partial cds
					# gb|BC141940.1| Homo sapiens similar to TBC1 domain family, member 2B, mRNA (cDNA 
					#clone MGC:165267 IMAGE:40132506), complete cds
					# gb|BC150505.1| Homo sapiens similar to TBC1 domain family, member 2B, mRNA (cDNA 
					#clone MGC:179648 IMAGE:40132514), complete cds
					#Length=392
					blast_result[:seq_name]=$1[0..254]

					blast_result[:seq_length]=$2
					blast_result[:accession]=blast_result[:seq_name].split('|')[1]

					seq_name_parts = blast_result[:seq_name].split('|')
					blast_result[:accession_prefix]=seq_name_parts[0]
					blast_result[:accession]=seq_name_parts[1]
					if( blast_result[:accession_prefix] == 'pdb' )
						blast_result[:accession] << "_#{seq_name_parts[2].split()[0]}"	# some are 2 chars
					end

					line=''
				elsif( l.match(/^>/) )
					line=l.chomp
					#	won't at the very first match
					if( blast_result.has_key?(:strand) )
						puts blast_result.inspect
						BlastResult.create!(blast_result)
						blast_result.delete(:bitscore)
						blast_result.delete(:score)
						blast_result.delete(:expect)
						blast_result.delete(:identities)
						blast_result.delete(:identities_percent)
						blast_result.delete(:gaps)
						blast_result.delete(:gaps_percent)
						blast_result.delete(:strand)
						blast_result.delete(:hit_rank)
					end
				elsif( l.match(/^ Score =\s+(.+) bits \((\d+)\),  Expect = (.+)$/) )
					#	Some hits are in multiple pieces.
					#	This is used to ONLY use the FIRST datum.
					if blast_result[:expect].blank?
						hit_rank = count unless $3 == prev_expect
					end
					blast_result.reverse_merge!({
						:hit_rank => hit_rank,
						:bitscore => $1,
						:score    => $2,
						:expect   => $3
					})
					prev_expect = blast_result[:expect]
				elsif( l.match(/^ Identities = (.+) \((\d+)%\), Gaps = (.+) \((\d+)%\)$/) )
					#	Also, only want the first set so reverse_merge!
					blast_result.reverse_merge!({
						:identities         => $1,
						:identities_percent => $2,
						:gaps               => $3,
						:gaps_percent       => $4
					})
				elsif( l.match(/^ Strand=(.+)$/) )
					#	Also, only want the first set so reverse_merge!
					#	I use :strand as a trigger.
					blast_result.reverse_merge!({
						:strand => $1
					})
				elsif( l.match(/ No hits found /) )
					#	***** No hits found *****
					#	continue to read lines, but do not try to create result as will be empty and fail.
					hits_found=false

				elsif( l.match(/^Effective search space used:/) )
					if hits_found
						puts blast_result.inspect
						BlastResult.create!(blast_result)
					else
						puts "No hits found.  Skipping."
						hits_found=true
					end
					blast_result=blast_defaults.dup
				end

			end	#	(f=File.open(ENV['file'],'rb')).each do |l|

		end	#	Dir[ ENV['file'] ].each do |filename|

		Sunspot.commit
		puts "End #{Time.now}"
	end	#	task :import => :environment do



	def env_required(var,msg='is required')
		if ENV[var].blank?
			puts
			puts "'#{var}' is not set and #{msg}"
			puts "Rerun with #{var}=something"
			puts
			exit(1)
		end
	end

	def file_required(filename,msg='is required')
		unless File.exists?(filename)
			puts
			puts "File '#{filename}' was not found and #{msg}"
			puts
			exit(1)
		end
	end

end	#	namespace :blast_results do
end	#	namespace :app


__END__




{:file_name=>"trinity_non_human_paired.blastn.txt", :contig_description=>"comp226_c0_seq1 len=136 path=[455:0-135]", :contig_name=>"comp226_c0_seq1", :contig_length=>nil, :seq_name=>"emb|AL627266.1| Salmonella enterica serovar Typhi (Salmonella typhi) strain CT18, complete chromosome; segment 2/20", :seq_length=>"268050", :accession=>"AL627266.1", :bitscore=>"71.3", :score=>"38", :expect=>"2e-09", :identities=>"38/38", :identities_percent=>"100", :gaps=>"0/38", :gaps_percent=>"0", :strand=>"Plus/Minus"}
{:file_name=>"trinity_non_human_paired.blastn.txt", :contig_description=>"comp226_c0_seq1 len=136 path=[455:0-135]", :contig_name=>"comp226_c0_seq1", :contig_length=>nil, :seq_name=>"pdb|2AWB|B Chain B, Crystal Structure Of The Bacterial Ribosome From Escherichia Coli At 3.5 A Resolution. This File Contains The 50s Subunit Of The Second 70s Ribosome. The Entire Crystal Structure Contains Two 70s Ribosomes And Is Described In Remark 400. pdb|2J28|B Chain B, Model Of E. Coli Srp Bound To 70s Rncs pdb|1VS8|B Chain B, Crystal Structure Of The Bacterial Ribosome From Escherichia Coli In Complex With The Antibiotic Kasugamyin At 3.5a Resolution. This File Contains The 50s Subunit Of One 70s Ribosome. The Entire Crystal Structure Contains Two 70s Ribosomes And Is Described In Remark 400.", :seq_length=>"2904", :accession=>"2AWB", :bitscore=>"71.3", :score=>"38", :expect=>"2e-09", :identities=>"38/38", :identities_percent=>"100", :gaps=>"0/38", :gaps_percent=>"0", :strand=>"Plus/Minus"}
{:file_name=>"trinity_non_human_paired.blastn.txt", :contig_description=>"comp226_c0_seq1 len=136 path=[455:0-135]", :contig_name=>"comp226_c0_seq1", :contig_length=>nil, :seq_name=>"pdb|1VS6|B Chain B, Crystal Structure Of The Bacterial Ribosome From Escherichia Coli In Complex With The Antibiotic Kasugamyin At 3.5a Resolution. This File Contains The 50s Subunit Of One 70s Ribosome. The Entire Crystal Structure Contains Two 70s Ribosomes And Is Described In Remark 400. pdb|3BBX|B Chain B, The Hsp15 Protein Fitted Into The Low Resolution Cryo-Em Map 50s.Nc-Trna.Hsp15 Complex pdb|3DG0|B Chain B, Coordinates Of 16s And 23s Rrnas Fitted Into The Cryo-Em Map Of Ef-G-Bound Translocation Complex pdb|3DG2|B Chain B, Coordinates Of 16s And 23s Rrnas Fitted Into The Cryo-Em Map Of A Pretranslocation Complex pdb|3DG4|B Chain B, Coordinates Of 16s And 23s Rrnas Fitted Into The Cryo-Em Map Of Rf1-Bound Termination Complex pdb|3DG5|B Chain B, Coordinates Of 16s And 23s Rrnas Fitted Into The Cryo-Em Map Of Rf3-Bound Termination Complex pdb|1VT2|A Chain A, Crystal Structure Of The E. Coli Ribosome Bound To Cem-101. This File Contains The 50s Subunit Of The Second 70s Ribosome.", :seq_length=>"2904", :accession=>"1VS6", :bitscore=>"71.3", :score=>"38", :expect=>"2e-09", :identities=>"38/38", :identities_percent=>"100", :gaps=>"0/38", :gaps_percent=>"0", :strand=>"Plus/Minus"}

Stumbled upon the really long names.  Seems that they are actually this long.
Unfortunately, I've defined the database field as a string of 256 chars
so over half of these long names will be truncated.  No worries though
as they are still in the nt database to get if needed.


>pdb|2AWB|B Chain B, Crystal Structure Of The Bacterial Ribosome From Escherichia
Coli At 3.5 A Resolution. This File Contains The 50s
Subunit Of The Second 70s Ribosome. The Entire Crystal Structure
Contains Two 70s Ribosomes And Is Described In Remark
400.
 pdb|2J28|B Chain B, Model Of E. Coli Srp Bound To 70s Rncs
 pdb|1VS8|B Chain B, Crystal Structure Of The Bacterial Ribosome From Escherichia
Coli In Complex With The Antibiotic Kasugamyin At 3.5a
Resolution. This File Contains The 50s Subunit Of One 70s
Ribosome. The Entire Crystal Structure Contains Two 70s Ribosomes
And Is Described In Remark 400.
Length=2904

 Score = 71.3 bits (38),  Expect = 2e-09
 Identities = 38/38 (100%), Gaps = 0/38 (0%)
 Strand=Plus/Minus

Query  1     CAGACTGGCGTCCACACTTCAAAGCCTCCCACCTATCC  38
             ||||||||||||||||||||||||||||||||||||||
Sbjct  2152  CAGACTGGCGTCCACACTTCAAAGCCTCCCACCTATCC  2115


>pdb|1VS6|B Chain B, Crystal Structure Of The Bacterial Ribosome From Escherichia
Coli In Complex With The Antibiotic Kasugamyin At 3.5a
Resolution. This File Contains The 50s Subunit Of One 70s
Ribosome. The Entire Crystal Structure Contains Two 70s Ribosomes
And Is Described In Remark 400.
 pdb|3BBX|B Chain B, The Hsp15 Protein Fitted Into The Low Resolution Cryo-Em
Map 50s.Nc-Trna.Hsp15 Complex
 pdb|3DG0|B Chain B, Coordinates Of 16s And 23s Rrnas Fitted Into The Cryo-Em
Map Of Ef-G-Bound Translocation Complex
 pdb|3DG2|B Chain B, Coordinates Of 16s And 23s Rrnas Fitted Into The Cryo-Em
Map Of A Pretranslocation Complex
 pdb|3DG4|B Chain B, Coordinates Of 16s And 23s Rrnas Fitted Into The Cryo-Em
Map Of Rf1-Bound Termination Complex
 pdb|3DG5|B Chain B, Coordinates Of 16s And 23s Rrnas Fitted Into The Cryo-Em
Map Of Rf3-Bound Termination Complex
 pdb|1VT2|A Chain A, Crystal Structure Of The E. Coli Ribosome Bound To Cem-101.
This File Contains The 50s Subunit Of The Second 70s
Ribosome.
Length=2904

 Score = 71.3 bits (38),  Expect = 2e-09
 Identities = 38/38 (100%), Gaps = 0/38 (0%)
 Strand=Plus/Minus




