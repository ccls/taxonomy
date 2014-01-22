#require 'csv'
namespace :app do
namespace :nodes do

	def set_left_children_right(parents,seq=0,depth=0)
		parents.update_all(:depth => depth+=1)
		puts "Updated depth to #{depth}"
		puts "Seq at #{seq}"
		parents.each do |parent|
			parent.update_column(:lft,seq+=1)
			children = parent.children
			parent.update_column(:children_count,children.length)
			seq = set_left_children_right(children,seq,depth)
			parent.update_column(:rgt,seq+=1)
		end
		depth-=1
		return seq
	end

	#
	#	Node.rebuild! is projected to take abou 15 days to process the >1million records
	#	The output looks like this for each.
	#
	#  Node Load (0.2ms)  SELECT `nodes`.* FROM `nodes` WHERE (`nodes`.`parent_id` = 244687 
	#			) ORDER BY `nodes`.`lft`, `nodes`.`rgt`, id
	#   (0.1ms)  BEGIN
	#   (0.2ms)  UPDATE `nodes` SET `lft` = 288255, `rgt` = 288256 WHERE `nodes`.`id` = 244687
	#  Node Load (0.2ms)  SELECT `nodes`.* FROM `nodes` WHERE `nodes`.`id` = 244687 LIMIT 1
	#   (509.7ms)  SELECT COUNT(*) FROM `nodes` WHERE (`nodes`.`lft` <= 288255 AND 
	#			`nodes`.`rgt` >= 288256) AND (`nodes`.id != 244687)
	#  SQL (0.3ms)  UPDATE `nodes` SET `depth` = 0 WHERE `nodes`.`id` = 244687 ORDER BY `nodes`.`lft`
	#   (526.5ms)  SELECT COUNT(*) FROM `nodes` WHERE (`nodes`.`lft` <= 288255 AND 
	#			`nodes`.`rgt` >= 288256) AND (`nodes`.id != 244687)
	#   (49.4ms)  COMMIT
	#
	#	Spends a lot of time looking for lft and rgt, when there are none to begin with.
	#		1 second per record for 1 million records yields 12 days
	#	> 1000000/60/60/24.0
	#	=> 11.541666666666666
	#
	#	My little version here did the same thing in under 8 hours!
	#
	#	Not sure what they are doing or why, but I think they are trying to compute
	#	the depth, but that is unlikely to be valid if the tree isn't complete or valid.
	#
	#	Not going to use the awesome_nested_set gem as won't provide any
	#	functionality for us.  Once the tree is built, we're done.
	#

	task :build_nested_set => :environment do
		set_left_children_right(Node.roots)
	end


#	#
#	#	by level 9, the mysql command is apparently too long
#	#	due to the number of parent_ids that it crashes
#	#	Adding a find_in_batches block to see if helps.
#	#	The batches still fail.  The mysql command is still the same length.
#	#		Trying each_slice.  YAY!
#	#
#	# Do this AFTER running Node.rebuild! as it sets the depth to 0 for everything!
#	#
#	task :rebuild_depth => :environment do
#		#	Sadly, after waiting days to build the nested set,
#		#	the depth attribute is not set.
#		parent_ids = [nil]
#		depth = 0
#		while !parent_ids.empty?
#			puts "Depth:#{depth}"
#			new_parent_ids = []
#			parent_ids.each_slice(50000) do |slice|
#				parents = Node.where(:parent_id => slice)	#	NEED to limit the sql command length here!
#				new_parent_ids += parents.collect(&:id)
#				parents.update_all :depth => depth
#				puts "New Parent ids length:#{new_parent_ids.length}"
#			end
#			parent_ids = new_parent_ids
#			puts "Parent ids length:#{parent_ids.length}"
#			depth += 1
#		end
#	end

#Depth:0
#Parent ids length:1
#Depth:1
#Parent ids length:5
#Depth:2
#Parent ids length:38
#Depth:3
#Parent ids length:1400
#Depth:4
#Parent ids length:26355
#Depth:5
#Parent ids length:32991
#Depth:6
#Parent ids length:22328
#Depth:7
#Parent ids length:38868
#Depth:8
#Parent ids length:236408
#Depth:9

	task :import => :environment do 
		puts Time.now
#		#
#		#	THESE FILES DO NOT HAVE COLUMN HEADERS SO MUST USE INDEX
#		#
#		(f=CSV.open("data/nodes.dmp",
#				'rb',{ :headers => false, :col_sep => "|" })).each do |line|
#			#	squish is rails
#			line.collect!(&:to_s).collect!(&:squish!)
#			puts "Processing line #{f.lineno}:#{line}"
##			taxid = line[0].to_i
##			parent_taxid = line[1].to_i
##if taxid == 1 and parent_taxid == 1
##	parent_taxid = nil
##end
#			#	Using block so can assign id
#			Node.create! do |n|
#				n.id = taxid
#				n.taxid = taxid
#				n.parent_taxid = parent_taxid
#				n.rank = line[2]
#			end
#		end #		(f=CSV.open("data/nodes.dmp",

		#
		#	The above ruby takes hours
		#	The below sql takes less than 2 minutes.
		#	I'm gonna change the names and identifiers imports as well.
		#	
		ActiveRecord::Base.connection.execute("DELETE FROM nodes;");
#		ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/nodes.dmp' INTO TABLE nodes FIELDS TERMINATED BY '\t|\t' LINES TERMINATED BY '\n' (id,parent_id,rank,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore);")
		ActiveRecord::Base.connection.execute("LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/nodes.dmp' INTO TABLE nodes FIELDS TERMINATED BY '\t|\t' LINES TERMINATED BY '\n' (taxid,parent_taxid,rank,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore);")

		#	acts as nested set needs the roots to have null parent_id's
		#	only 1 here
		Node.where(:taxid => 1).first.update_column(:parent_taxid, nil)

#	This WILL take a while.  DAYS! (~3000/hour) 1092643 total so about 20 days
#	so not putting it here. Wonder how long it would've taken to just import with ruby.
#	Would have to sort properly as won't be able to add a node unless its 
#	parent already exists.
#		Node.rebuild!

		puts Time.now
	end	#	task :import => :environment do 




	def nodes_to_json(nodes)
		nodes.each do |node|
			print "#{' '*node.depth}{\"name\": \"#{node.scientific_name.to_s}\""
				print ",\"size\": #{node.children_count+1}"
			if node.children.present? and node.depth < 6
				print ",\n"
				puts "#{' '*node.depth} \"children\": ["
				nodes_to_json(node.children)
				puts "#{' '*node.depth}]"
			else
#				print "\n"
#				print ",\"size\": #{(node.rgt - node.lft + 1)/2}"
#				print ",\"size\": 1"
			end
			if node == nodes.last
				puts "#{' '*node.depth}}"
			else
				puts "#{' '*node.depth}},"
			end
		end
	end

#	"sunburst" and "partition" json styles don't quite have the same expectations
#	The "partition" style requires size and a single root value, but not []
#	The "sunburst" style doesn't use size, but tolerates it presences.
#		It also seems to require a [] wrapper.
#	Its all in the parsing I guess, as different people write the javascript.

	task :to_json => :environment do
#		puts "["
#		Node.roots.each do |node|
#			nodes_to_json(node.children)
#		end
		nodes_to_json(Node.roots)
#		puts "]"
	end

end	#	namespace :nodes do
end	#	namespace :app

__END__

first found on 
http://forumone.com/blogs/post/how-selectively-import-data-data-file-mysql-5
but is thoroughly described ...
http://dev.mysql.com/doc/refman/5.0/en/load-data.html




LOAD DATA INFILE '/Users/jakewendt/github_repo/ccls/taxonomy/data/nodes.dmp' INTO TABLE nodes FIELDS TERMINATED BY '\t|\t' LINES TERMINATED BY '\n' (id,parent_taxid,rank,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore,@ignore);



(country,zip,city,@ignore,@ignore,@ignore,@ignore,@ignore,latitude,longitude);

	tax_id					-- node id in GenBank taxonomy database
 	parent tax_id				-- parent node id in GenBank taxonomy database
 	rank					-- rank of this node (superkingdom, kingdom, ...) 
 	embl code				-- locus-name prefix; not unique
 	division id				-- see division.dmp file
 	inherited div flag  (1 or 0)		-- 1 if node inherits division from parent
 	genetic code id				-- see gencode.dmp file
 	inherited GC  flag  (1 or 0)		-- 1 if node inherits genetic code from parent
 	mitochondrial genetic code id		-- see gencode.dmp file
 	inherited MGC flag  (1 or 0)		-- 1 if node inherits mitochondrial gencode from parent
 	GenBank hidden flag (1 or 0)            -- 1 if name is suppressed in GenBank entry lineage
 	hidden subtree root flag (1 or 0)       -- 1 if this subtree has no sequence data yet
 	comments





Depth:0
New Parent ids length:1
Parent ids length:1
Depth:1
New Parent ids length:5
Parent ids length:5
Depth:2
New Parent ids length:38
Parent ids length:38
Depth:3
New Parent ids length:1400
Parent ids length:1400
Depth:4
New Parent ids length:26355
Parent ids length:26355
Depth:5
New Parent ids length:32991
Parent ids length:32991
Depth:6
New Parent ids length:22328
Parent ids length:22328
Depth:7
New Parent ids length:38868
Parent ids length:38868
Depth:8
New Parent ids length:236408
Parent ids length:236408
Depth:9
New Parent ids length:62615
New Parent ids length:75553
New Parent ids length:77495
New Parent ids length:78433
New Parent ids length:79115
Parent ids length:79115
Depth:10
New Parent ids length:53085
New Parent ids length:60032
Parent ids length:60032
Depth:11
New Parent ids length:9021
New Parent ids length:12322
Parent ids length:12322
Depth:12
New Parent ids length:13901
Parent ids length:13901
Depth:13
New Parent ids length:32491
Parent ids length:32491
Depth:14
New Parent ids length:16721
Parent ids length:16721
Depth:15
New Parent ids length:35179
Parent ids length:35179
Depth:16
New Parent ids length:43427
Parent ids length:43427
Depth:17
New Parent ids length:32563
Parent ids length:32563
Depth:18
New Parent ids length:38500
Parent ids length:38500
Depth:19
New Parent ids length:29764
Parent ids length:29764
Depth:20
New Parent ids length:35103
Parent ids length:35103
Depth:21
New Parent ids length:47494
Parent ids length:47494
Depth:22
New Parent ids length:53705
Parent ids length:53705
Depth:23
New Parent ids length:8864
New Parent ids length:9528
Parent ids length:9528
Depth:24
New Parent ids length:13095
Parent ids length:13095
Depth:25
New Parent ids length:27662
Parent ids length:27662
Depth:26
New Parent ids length:27447
Parent ids length:27447
Depth:27
New Parent ids length:20617
Parent ids length:20617
Depth:28
New Parent ids length:13825
Parent ids length:13825
Depth:29
New Parent ids length:18762
Parent ids length:18762
Depth:30
New Parent ids length:24345
Parent ids length:24345
Depth:31
New Parent ids length:18277
Parent ids length:18277
Depth:32
New Parent ids length:8812
Parent ids length:8812
Depth:33
New Parent ids length:6420
Parent ids length:6420
Depth:34
New Parent ids length:2079
Parent ids length:2079
Depth:35
New Parent ids length:4626
Parent ids length:4626
Depth:36
New Parent ids length:4037
Parent ids length:4037
Depth:37
New Parent ids length:1564
Parent ids length:1564
Depth:38
New Parent ids length:2556
Parent ids length:2556
Depth:39
New Parent ids length:261
Parent ids length:261
Depth:40
New Parent ids length:19
Parent ids length:19
Depth:41
New Parent ids length:0
Parent ids length:0
