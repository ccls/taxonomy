class BlastResult < ActiveRecord::Base
	attr_accessible :accession, :bitscore, :contig_name, :contig_length, 
		:contig_description, :expect, :file_name, :gaps, :gaps_percent, 
		:identities, :identities_percent, :score, :seq_name, :seq_length, :strand

	belongs_to :identifier, :foreign_key => :accession, :primary_key => :accession
	has_many :names, :through => :identifier
	has_one  :node , :through => :identifier
	#delegate :ancestors, :to => :node, :allow_nil => true
	#	ancestors go to the leaves of the tree (useless)
	#	descendants go to the root of the tree
	#delegate :descendants, :to => :node, :allow_nil => true

	def descendants
		@descendants ||= node.descendants
	end

	validates_presence_of :accession, :bitscore, :contig_name, :contig_length, 
		:contig_description, :expect, :file_name, :gaps, :gaps_percent, 
		:identities, :identities_percent, :score, :seq_name, :seq_length, :strand

	include Sunspotability

	add_sunspot_column( :id, :type => :integer, :default => true )
	add_sunspot_column( :file_name, :facetable => true, :default => true )
	add_sunspot_column( :accession, :default => true )
	add_sunspot_column( :name, :facetable => true, 
		:meth => ->(s){ s.names.scientific.first || 'NULL?' } )
	add_sunspot_column( :expect, :default => true, :facetable => true,
		:range => {
			:start => 1e-30,
			:stop  => 1e-20,
			:step  => 1000
		} )	#	would prefer some type of logarithmic scale

	add_sunspot_column( :strand, :facetable => true, :default => true )

#	add_sunspot_column( :ancestors, :facetable => true, :multiple => true,
#		:meth => ->(s){ s.ancestors.collect{|a| a.names.scientific.first } } )

	add_sunspot_column( :descendant_0, :facetable => true, 
		:meth => ->(s){ s.descendants[0].try(:scientific_name) } )
	add_sunspot_column( :descendant_1, :facetable => true, 
		:meth => ->(s){ s.descendants[1].try(:scientific_name) } )
	add_sunspot_column( :descendant_2, :facetable => true, 
		:meth => ->(s){ s.descendants[2].try(:scientific_name) } )
	add_sunspot_column( :descendant_3, :facetable => true, 
		:meth => ->(s){ s.descendants[3].try(:scientific_name) } )
	add_sunspot_column( :descendant_4, :facetable => true, 
		:meth => ->(s){ s.descendants[4].try(:scientific_name) } )
	add_sunspot_column( :descendant_5, :facetable => true, 
		:meth => ->(s){ s.descendants[5].try(:scientific_name) } )
	add_sunspot_column( :descendant_6, :facetable => true, 
		:meth => ->(s){ s.descendants[6].try(:scientific_name) } )
	add_sunspot_column( :descendant_7, :facetable => true, 
		:meth => ->(s){ s.descendants[7].try(:scientific_name) } )
	add_sunspot_column( :descendant_8, :facetable => true, 
		:meth => ->(s){ s.descendants[8].try(:scientific_name) } )
	add_sunspot_column( :descendant_9, :facetable => true, 
		:meth => ->(s){ s.descendants[9].try(:scientific_name) } )

	add_sunspot_column( :descendant_10, :facetable => true, 
		:meth => ->(s){ s.descendants[10].try(:scientific_name) } )
	add_sunspot_column( :descendant_11, :facetable => true, 
		:meth => ->(s){ s.descendants[11].try(:scientific_name) } )
	add_sunspot_column( :descendant_12, :facetable => true, 
		:meth => ->(s){ s.descendants[12].try(:scientific_name) } )
	add_sunspot_column( :descendant_13, :facetable => true, 
		:meth => ->(s){ s.descendants[13].try(:scientific_name) } )
	add_sunspot_column( :descendant_14, :facetable => true, 
		:meth => ->(s){ s.descendants[14].try(:scientific_name) } )
	add_sunspot_column( :descendant_15, :facetable => true, 
		:meth => ->(s){ s.descendants[15].try(:scientific_name) } )
	add_sunspot_column( :descendant_16, :facetable => true, 
		:meth => ->(s){ s.descendants[16].try(:scientific_name) } )
	add_sunspot_column( :descendant_17, :facetable => true, 
		:meth => ->(s){ s.descendants[17].try(:scientific_name) } )
	add_sunspot_column( :descendant_18, :facetable => true, 
		:meth => ->(s){ s.descendants[18].try(:scientific_name) } )
	add_sunspot_column( :descendant_19, :facetable => true, 
		:meth => ->(s){ s.descendants[19].try(:scientific_name) } )

	add_sunspot_column( :descendant_20, :facetable => true, 
		:meth => ->(s){ s.descendants[20].try(:scientific_name) } )
	add_sunspot_column( :descendant_21, :facetable => true, 
		:meth => ->(s){ s.descendants[21].try(:scientific_name) } )
	add_sunspot_column( :descendant_22, :facetable => true, 
		:meth => ->(s){ s.descendants[22].try(:scientific_name) } )
	add_sunspot_column( :descendant_23, :facetable => true, 
		:meth => ->(s){ s.descendants[23].try(:scientific_name) } )
	add_sunspot_column( :descendant_24, :facetable => true, 
		:meth => ->(s){ s.descendants[24].try(:scientific_name) } )
	add_sunspot_column( :descendant_25, :facetable => true, 
		:meth => ->(s){ s.descendants[25].try(:scientific_name) } )
	add_sunspot_column( :descendant_26, :facetable => true, 
		:meth => ->(s){ s.descendants[26].try(:scientific_name) } )
	add_sunspot_column( :descendant_27, :facetable => true, 
		:meth => ->(s){ s.descendants[27].try(:scientific_name) } )
	add_sunspot_column( :descendant_28, :facetable => true, 
		:meth => ->(s){ s.descendants[28].try(:scientific_name) } )
	add_sunspot_column( :descendant_29, :facetable => true, 
		:meth => ->(s){ s.descendants[29].try(:scientific_name) } )

#	most are the same up to 21.
#
#irb(main):007:0> Node.group(:depth).count
#   (1339.8ms)  SELECT COUNT(*) AS count_all, depth AS depth FROM `nodes` GROUP BY depth
#=> {1=>1, 2=>5, 3=>38, 4=>1400, 5=>26355, 6=>32991, 7=>22328, 8=>38868, 9=>236408, 10=>79115, 11=>60032, 12=>12322, 13=>13901, 14=>32491, 15=>16721, 16=>35179, 17=>43427, 18=>32563, 19=>38500, 20=>29764, 21=>35103, 22=>47494, 23=>53705, 24=>9528, 25=>13095, 26=>27662, 27=>27447, 28=>20617, 29=>13825, 30=>18762, 31=>24345, 32=>18277, 33=>8812, 34=>6420, 35=>2079, 36=>4626, 37=>4037, 38=>1564, 39=>2556, 40=>261, 41=>19}

	add_sunspot_column( :descendants, :facetable => true, :multiple => true,
		:meth => ->(s){ s.descendants.collect{|a| a.scientific_name } } )

	searchable_plus




#{:file_name=>"small_trinity_non_human_paired.blastn.txt", :contig_name=>"comp1_c0_seq1 len=104 path=[237:0-56 123:57-80 350:81-103]", :contig_length=>"104", :seq_name=>"gb|AC151056.2| Pan troglodytes BAC clone CH251-310D9 from chromosome y, complete sequence", :seq_length=>"135628", :accession=>"AC151056.2", :bitscore=>"58.4", :score=>"31", :expect=>"9e-06", :identities=>"35/37", :identities_percent=>"95", :gaps=>"0/37", :gaps_percent=>"0", :strand=>"Plus/Minus"}
end

#	if no hits in blast files, ancestors is nil
class NilClass
	def collect
		[]
	end
end

__END__

I've never encountered this before, primarily because I've never had so much data.
There is a default limit of 100 facet values.  

	This param indicates the maximum number of constraint counts that should be returned for the facet fields. A negative value means unlimited.
	The default value is 100.
	This parameter can be specified on a per field basis to indicate a separate limit for certain fields.


When you pass the limit the sort no longer defaults to count so you need to set the sort manually.

	query.facet(:name, :limit => -1, :sort => :count)

http://wiki.apache.org/solr/SimpleFacetParameters#facet.limit

I would imagine that returning all of the facets would be memory intensive.
I've got half a million records and many of these facet counts are small.

