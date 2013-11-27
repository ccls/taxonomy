namespace :app do
namespace :blast_results do

	task :import => :environment do 
		puts "Start #{Time.now}"
		env_required('file')
		file_required(ENV['file'])

		blast_defaults = {:file_name => ENV['file']}
		blast_result = blast_defaults.dup
		line=''
		
		(f=File.open(ENV['file'],'rb')).each do |l|
			line=line+l.chomp

			#	first will include all the header stuff
			if( line.match(/Query= (.*)Length=(\d+)$/) )
				blast_result=blast_defaults.dup
				blast_result[:contig_description]=$1
				blast_result[:contig_name]=$1.split(/\s+/)[0]
				blast_result[:contig_length]=$2
				line=''
			elsif( l.match(/Query= /) )
				line=l.chomp
			elsif( line.match(/^>(.*)Length=(\d+)$/) )
				blast_result[:seq_name]=$1
				blast_result[:seq_length]=$2
				blast_result[:accession]=$1.split('|')[1]
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

# Score = 58.4 bits (31),  Expect = 9e-06
# Identities = 35/37 (95%), Gaps = 0/37 (0%)
# Strand=Plus/Minus

			elsif( l.match(/^ Score =\s+(.+) bits \((\d+)\),  Expect = (.+)$/) )
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
			elsif( l.match(/^Effective search space used:/) )
				BlastResult.create!(blast_result)
				puts blast_result.inspect
				blast_result=blast_defaults.dup
			end

		end

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
