#require 'csv'
namespace :app do
namespace :identifiers do

	task :import => :environment do 
		puts Time.now
#		#
#		#	THESE FILES DO NOT HAVE COLUMN HEADERS SO MUST USE INDEX
#		#
#		(f=CSV.open("accession_gi_taxid.csv",
#				'rb',{ :headers => false })).each do |line|
#			#	squish is rails
#			line.collect!(&:to_s).collect!(&:squish!)
#			puts "Processing line #{f.lineno}:#{line}"
#			Identifier.create!(
#				:accession => line[0],
#				:gi => line[1],
#				:taxid => line[2]
#			)
#		end

		#
		#	The above ruby takes over a day! (>26 million rows) (1 million rows / hour )?
		#	The below sql takes about 45 minutes.
		#	I'm gonna change the names and identifiers imports as well.
		#	
		ActiveRecord::Base.connection.execute("DELETE FROM identifiers;");
		ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/accession_gi_taxid.csv' INTO TABLE identifiers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (accession,gi,taxid);")

		puts Time.now
	end	#	task :import => :environment do 

end	#	namespace :identifiers do
end	#	namespace :app
