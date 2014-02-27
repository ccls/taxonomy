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
		#	Just did this import again with a larger file and it took ... hours?
		#	
		ActiveRecord::Base.connection.execute("DELETE FROM identifiers;");
		#		ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/nt.accession_gi_taxid.csv' INTO TABLE identifiers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (accession,gi,taxid);")
		#
		#		ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/nt_and_g2a.accession_gi_taxid.sorted.uniq.csv' INTO TABLE identifiers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (accession,gi,taxid);")
		#
		#	The original accession_gi_taxid.csv extracted from the nt database does not
		#	include RefSeq accession numbers used in the viral_genomic database. In attempt
		#	to merge the two, I have found that they are different enough to be a problem.
		#	Seems that gene2accession has many differing associations between accession number and taxid.
		#	This causes the merging with the nt accession to have non-unique identifiers.
		#	I could just merge the gene2refseq with the nt results, but I'm going to try to just 
		#	use the gene2accession by itself.  This is a drop from 26M to 7M identifiers.
		#	I suspect that many will be missing, but we shall see.
		#	
		#	This fails as well.  gene2accession by itself has accession numbers associated with 
		#	multiple gi numbers or taxids!!  Only 12, but not 0.
		#		AB042523.1
		#		AB042524.1
		#		AB042809.1
		#		AE016877.1
		#		AY506529.1
		#		BA000018.3
		#		DQ279927.1
		#		GQ468938.1
		#		NC_016348.1
		#		NC_016402.1
		#		X72004.1
		#		X72204.1
		#
		#ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/gene2accession.accession_gi_taxid.sorted.uniq.csv' INTO TABLE identifiers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (accession,gi,taxid);")

		#
		#	If this doesn't work, perhaps I should extract this info from the viral_genomics
		#	database just as I have from the nt database and then merge them.
		#	Just extracted from viral_genomics database.  Does not include taxid, so unusable.
		#
		#	Seems g2r also has the two NC_* duplicates as gene2accession
		#
		#ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/nt_and_g2r.accession_gi_taxid.sorted.uniq.csv' INTO TABLE identifiers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (accession,gi,taxid);")


		#
		#	Investigating the above duplicates and will be leaving just one. (kept the first)
		#		AB042523.1,7804453,10090
		#		AB042523.1,7804453,10092
		#
		#		AB042524.1,7798599,10090
		#		AB042524.1,7798599,10092
		#		
		#		AB042809.1,8096291,10090
		#		AB042809.1,8096291,10092
		#		
		#		AE016877.1,29899096,225725
		#		AE016877.1,29899096,225726
		#		AE016877.1,29899096,226900
		#			
		#		AY506529.1,40794996,381124
		#		AY506529.1,40794996,4577
		#		
		#		BA000018.3,47118324,158879
		#		BA000018.3,47118324,225979
		#		
		#		DQ279927.1,82703946,10376
		#		DQ279927.1,82703946,12509
		#		
		#		GQ468938.1,294869143,1367847
		#		GQ468938.1,294869143,34003
		#		
		#		NC_016348.1,358051046,39899
		#		NC_016348.1,358051052,39899
		#		
		#		NC_016402.1,357967309,42043
		#		NC_016402.1,357967335,42043
		#		
		#		X72004.1,414757,9711
		#		X72004.1,414757,9720
		#		
		#		X72204.1,414126,9770
		#		X72204.1,414126,9771
		#
		#	And now there are duplicate gi numbers too!!! (kept the first)
		#	(should probably keep those with a version)
		#		NC_016222.1,357967287,39875
		#		NC_016342.1,357967287,39875
		#		
		#		NC_016402.1,357967309,42043
		#		NC_016406.1,357967309,42043
		#		
		#		NW_001030773,82896373,10090
		#		NW_001030773.1,82896373,10090
		#		
		#		NW_001092861,86575411,7070
		#		NW_001092861.1,86575411,7070
		#		
		#		NW_001092892,86575446,7070
		#		NW_001092892.1,86575446,7070
		#		
		#		NW_001093987,86575521,7070
		#		NW_001093987.1,86575521,7070
		#		
		#		NW_001094328,86575562,7070
		#		NW_001094328.1,86575562,7070
		#
		#	And now no gi numbers.  Removed both.
		#		NC_002633.1,-,146499
		#		NC_002692.1,-,12253
		#
		#	Success!  Finally!  Now need to determine if I broke anything else.
		#	
		ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/gene2accession.accession_gi_taxid.sorted.uniq.manual.csv' INTO TABLE identifiers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (accession,gi,taxid);")

		puts Time.now
	end	#	task :import => :environment do 

end	#	namespace :identifiers do
end	#	namespace :app
