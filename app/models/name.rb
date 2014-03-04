class Name < ActiveRecord::Base
	attr_accessible :name_class, :name_txt, :name_unique, :taxid
	scope :scientific, ->{ where( name_class: "scientific name" )}
	def to_s
		name_txt
	end
end

__END__

.irb(main):001:0> Name.group(:name_class).count
   (5359.5ms)  SELECT COUNT(*) AS count_all, name_class AS name_class FROM `names` GROUP BY name_class
=> {"acronym"=>928, "anamorph"=>426, "authority"=>187164, "blast name"=>225, "common name"=>13519, "equivalent name"=>19231, "genbank acronym"=>377, "genbank anamorph"=>141, "genbank common name"=>23687, "genbank synonym"=>1980, "in-part"=>415, "includes"=>17127, "misnomer"=>1297, "misspelling"=>20662, "scientific name"=>1092643, "synonym"=>179958, "teleomorph"=>195, "type material"=>63605}

1:1 with "scientific name" only


Once the scientific name has been imported to the node, this model is unused.

