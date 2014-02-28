require 'csv'
namespace :app do
namespace :identifiers do

	task :update => :environment do
		puts Time.now
		env_required('file')
		(f=CSV.open( file, 'rb',{ :headers => false })).each do |line|
			#	squish is rails
			line.collect!(&:to_s).collect!(&:squish!)
			puts "Processing line #{f.lineno}:#{line}"
			identifiers = Identifier.where(:accession => line[0])
			if identifiers.empty?
				Identifier.create!(
					:accession => line[0],
					:gi => line[1],
					:taxid => line[2]
				)
			else
				identifiers.first.update_attributes!(
					:gi => line[1],
					:taxid => line[2]
				)
			end
		end	#	(f=CSV.open(file, 'rb',{ :headers => false })).each do |line|
	end	#	task :update => :environment do

#	as individual lines, if not valid, just moves on to the next line.
#	awk -F, {print "insert into identifiers (accession,gi,taxid) values (\""$1"\","$2","$3");"} nt_20131118.accession_gi_taxid.sorted.uniq.csv > import.sql
#	mysql> source import.sql

	#	attempt to add more identifiers from csv
	#	If invalid, just skip it.
	task :append => :environment do
		puts Time.now
		#	env_required('file')
		(f=CSV.open("data/older/nt_20131118.accession_gi_taxid.sorted.uniq.csv",
				'rb',{ :headers => false })).each do |line|
			#	squish is rails
			line.collect!(&:to_s).collect!(&:squish!)
			puts "Processing line #{f.lineno}:#{line}"
			# Attempt to add another.  If it is invalid it will fail, which is desired.
			Identifier.create(
				:accession => line[0],
				:gi => line[1],
				:taxid => line[2]
			)
		end
		puts Time.now
	end	#	task :append => :environment do

	task :import => :environment do 
		puts Time.now

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
		#	So many gaps.
		#
		#	ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/gene2accession.accession_gi_taxid.sorted.uniq.manual.csv' INTO TABLE identifiers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (accession,gi,taxid);")
		#
		#	Updating NCBI databases, extracting and combining all accession/gi/taxids
		#	There were 14 duplicates after combining.  
		#	I kept the entries from the other_genomic db which is newer than the refseq_genomic db.
		#
		ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/20140227/all.accession_gi_taxid.sorted.uniq.manual.csv' INTO TABLE identifiers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' (accession,gi,taxid);")

		puts Time.now
	end	#	task :import => :environment do 


#	task :add_taxids_to_viral_genomic => :environment do
#		(f=CSV.open("data/viral_genomic.accession_gi_taxid.csv.no_taxids",
#				'rb',{ :headers => false })).each do |line|
##grep NC_018104.1 gene2refseq.accession_gi_taxid.sorted.uniq.csv 
##NC_018104.1,394743611,167947
#			refseq=`grep #{line[0]} data/gene2refseq.accession_gi_taxid.sorted.uniq.csv`
#puts "#{line},#{refseq}"
#
#		end	#	(f=CSV.open("viral_genomic.accession_gi_taxid.csv.no_taxids",
#	end	#	task :add_taxids_to_viral_genomic => :environment do

end	#	namespace :identifiers do
end	#	namespace :app
