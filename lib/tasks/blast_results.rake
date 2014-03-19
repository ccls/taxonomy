namespace :app do
namespace :blast_results do

	task :index_select => :environment do
		BlastResult.where(BlastResult.arel_table[:file_name].matches("PBSF120213_SF02%")).find_each do |b|
			b.index
		end
		Sunspot.commit
	end

	task :check_hit_order => :environment do
		contig_name,hit_order,count,prev_expect=nil
#		contig_name=''
#		hit_order=1
#		count=1
#		prev_expect=nil
#		BlastResult.find_each do |b|
		BlastResult.where(BlastResult.arel_table[:id].gteq(26599950)).find_each do |b|
			if( contig_name != b.contig_name )
				hit_order=1
				count=1
				prev_expect=nil
				contig_name = b.contig_name
			else
				count+=1
				hit_order = count unless b.expect == prev_expect
			end
			puts "#{b.id} : #{b.file_name} : #{contig_name} : #{hit_order}"
			b.update_attributes!(:hit_order => hit_order)	#	will only actually update if different
			prev_expect = b.expect
		end
		Sunspot.commit
	end

	task :import => :environment do
		puts "Start #{Time.now}"
		env_required('file')
#		file_required(ENV['file'])


#	bundle exec rake app:blast_results:import file="/Volumes/cube/working/output/fallon_*/trinity_non_human_*.blastn.txt"


		files = Dir[ ENV['file'] ]
		puts files.inspect

		files.each do |file|

			filename = file.dup
#			filename.gsub!("/Volumes/cube/working/output/","")
#			filename.gsub!("_filtered","")
#			filename.gsub!(/_\d{8}/,"")

#			filename = filename.split('/').last
			filename = filename.split('/')[-2..-1].join('/')


			blast_defaults = {:file_name => filename}

			blast_result = blast_defaults.dup
			line=''
			hits_found=true

			hit_order,prev_expect,count=nil

			(f=File.open(file,'rb')).each do |l|
				line=line+l.chomp

				#	first will include all the header stuff
				if( line.match(/Query= (.*)Length=(\d+)$/) )
					blast_result=blast_defaults.dup
					blast_result[:contig_description]=$1
					blast_result[:contig_length]=$2
					blast_result[:contig_name]=blast_result[:contig_description].split(/\s+/)[0]
					count=1
					hit_order=1
					prev_expect=nil
					line=''
				elsif( l.match(/Query= /) )
					line=l.chomp
				elsif( line.match(/^>(.*)Length=(\d+)$/) )
					blast_result[:seq_name]=$1
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
					end


#	while expect was a float, the following value seems to be the 
#	lowest non-zero value preserved by the database
#	 1.401298464324817e-45
#MariaDB [taxonomy_development]> select id, expect from blast_results where expect > 0 and id < 10510697 group by expect order by expect asc limit 10;
#+--------+------------------------+
#| id     | expect                 |
#+--------+------------------------+
#|   2796 |  1.401298464324817e-45 |
#|  41534 |  2.802596928649634e-45 |
#|   3644 |  4.203895392974451e-45 |
#|   2841 |  5.605193857299268e-45 |
#|  35217 |  7.006492321624085e-45 |


				# Score = 58.4 bits (31),  Expect = 9e-06
				# Identities = 35/37 (95%), Gaps = 0/37 (0%)
				# Strand=Plus/Minus





#	NEW TODO !
#	Occassionally, one query sequence will match something, but have a large gap.
#	Instead of treating it as a gap, it does something like the following.  
#	What happens if more than one gap?  Which score is correct? First? Last?
#	The blastn summary uses the first stats.
#
#>ref|XM_003826044.1| PREDICTED: Pan paniscus matrix metallopeptidase 9 (gelatinase 
#B, 92kDa gelatinase, 92kDa type IV collagenase) (MMP9), mRNA
#Length=2374
#
# Score =  102 bits (55),  Expect = 4e-19
# Identities = 55/55 (100%), Gaps = 0/55 (0%)
# Strand=Plus/Minus
#
#Query  1     TGCGTGTCCAAAGGCACCCCGGGGAACATCCGGTCCACCTCGCTGGCGCTCCGGG  55
#             |||||||||||||||||||||||||||||||||||||||||||||||||||||||
#Sbjct  2039  TGCGTGTCCAAAGGCACCCCGGGGAACATCCGGTCCACCTCGCTGGCGCTCCGGG  1985
#
#
# Score = 97.1 bits (52),  Expect = 2e-17
# Identities = 52/52 (100%), Gaps = 0/52 (0%)
# Strand=Plus/Minus
#
#Query  50    TCCGGGAACTCACGCGCCAGTAGAAGCGGTCCTGGCAGAAATAGGCTTTCTC  101
#             ||||||||||||||||||||||||||||||||||||||||||||||||||||
#Sbjct  2110  TCCGGGAACTCACGCGCCAGTAGAAGCGGTCCTGGCAGAAATAGGCTTTCTC  2059
#
#

				elsif( l.match(/^ Score =\s+(.+) bits \((\d+)\),  Expect = (.+)$/) )
					
					count+=1
					hit_order = count unless b.expect == prev_expect
					blast_result[:hit_order]=hit_order

					blast_result[:bitscore]=$1
					blast_result[:score]=$2
					blast_result[:expect]=$3
				elsif( l.match(/^ Identities = (.+) \((\d+)%\), Gaps = (.+) \((\d+)%\)$/) )
					blast_result[:identities]=$1
					blast_result[:identities_percent]=$2
					blast_result[:gaps]=$3
					blast_result[:gaps_percent]=$4
				elsif( l.match(/^ Strand=(.+)$/) )
					blast_result[:strand]=$1
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




