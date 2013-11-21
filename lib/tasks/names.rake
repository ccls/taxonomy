require 'csv'
namespace :app do
namespace :names do

	task :import => :environment do 
		#
		#	THESE FILES DO NOT HAVE COLUMN HEADERS SO MUST USE INDEX
		#
#
#	several lines like ... make this complicated
#
#	10	|	"Cellvibrio" Winogradsky 1929	|		|	synonym	|
#		(f=CSV.open("names.dmp",
#				'rb',{ :headers => false, :col_sep => "|" })).each do |line|
#			#	squish is rails
#			line.collect!(&:to_s).collect!(&:squish!)
#			puts "Processing line #{f.lineno}:#{line}"
##			Name.create!(
##				:taxid => line[0],
##				:name_txt => line[1],
##				:name_unique => line[2],
##				:name_class => line[3]
##			)

#		(f=File.open("data/names.dmp",'rb')).each do |line|
#			parts = line.split("|").collect!(&:to_s).collect!(&:squish!)
#			puts "Processing line #{f.lineno}:#{parts.inspect}"
#			Name.create!(
#				:taxid => parts[0],
#				:name_txt => parts[1],
#				:name_unique => parts[2],
#				:name_class => parts[3]
#			)
#		end

		#
		#	The above ruby takes hours
		#	The below sql takes less than 2 minutes.
		#	I'm gonna change the names and identifiers imports as well.
		#	
		ActiveRecord::Base.connection.execute("DELETE FROM names;");
		ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/names.dmp' INTO TABLE names FIELDS TERMINATED BY '\t|\t' LINES TERMINATED BY '\t|\n' (taxid,name_txt,name_unique,name_class);")

	end	#	task :import => :environment do 

end	#	namespace :names do
end	#	namespace :app

__END__

Taxonomy names file (names.dmp):
	tax_id					-- the id of node associated with this name
	name_txt				-- name itself
	unique name				-- the unique variant of this name if name not unique
	name class

