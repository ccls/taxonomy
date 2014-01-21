
#
#	these are missing in sunspot 2.0
#
module Sunspot::Type
	class TrieDoubleType < DoubleType
		def indexed_name(name)
			"#{super}t"
		end
	end
	class TrieLongType < LongType
		def indexed_name(name)
			"#{super}t"
		end
	end
end

class BlastResult < ActiveRecord::Base
	attr_accessible :accession, :accession_prefix, :bitscore, :contig_name, :contig_length,
		:contig_description, :expect, :file_name, :gaps, :gaps_percent,
		:identities, :identities_percent, :score, :seq_name, :seq_length, :strand

	belongs_to :identifier, :foreign_key => :accession, :primary_key => :accession
	has_many :names, :through => :identifier
	has_one  :node , :through => :identifier

	scope :stray_accession_numbers, ->{ left_joins(:identifier).where(:"identifiers.gi" => nil) }
#	strays = BlastResult.left_joins(:identifier).where(:"identifiers.gi" => nil)
#irb(main):009:0> strays.collect(&:accession)
#=> ["3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "1C2W", "1P6V", "1P6V", "4A1D", "4A18", "4A1B", "2YMF", "3IZ9", "3IZ9", "3CW1", "3CW1", "2ZKR", "2ZKR", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2KX8", "2KX8", "2ZKR", "2ZKR", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "2ZKR", "2ZKR", "2ZKR", "3AN2", "3AN2", "2GO5", "2J37", "1L9A", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKQ", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2ZKR", "2Y9A", "2Y9A", "4A17", "4A1A", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "2AWB", "1VS6", "1C2W", "2GYC", "2GYA", "3IZT", "3FIK", "3E1B", "2I2V", "2AW4", "3V27", "3UXQ", "3PYV", "3PYT", "3PYR", "3PYO", "3MRZ", "3MS1", "3KNM", "2WRJ", "2WRL", "3HUX", "3FIN", "3D5B", "3D5D", "2HGJ", "2HGQ", "1YL3", "1VSA", "2B66", "1VSP", "1GIY", "4ABS", "4A1D", "4A18", "4A1B"]

#jakewendt@fxdgroup-169-229-196-225 : taxonomy 533> grep 3IZT data/accession_gi_taxid.csv
#3IZT_A,326634209,83333
#3IZT_B,326634210,83333
#jakewendt@fxdgroup-169-229-196-225 : taxonomy 534> grep 3IZT trinity_non_human_paired.blastn.txt
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...  71.3    2e-09
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   281    2e-72
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   143    4e-31
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   211    1e-51
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   215    7e-53
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   124    1e-25
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   187    1e-44
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   128    8e-27
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   156    4e-35
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   156    4e-35
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   193    3e-46
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   134    1e-28
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...   217    2e-53
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination
#pdb|3IZT|B  Chain B, Structural Insights Into Cognate Vs. Near-Co...  78.7    8e-12
#>pdb|3IZT|B Chain B, Structural Insights Into Cognate Vs. Near-Cognate Discrimination


#>pdb|1VSP|WW Chain w, Interactions And Dynamics Of The Shine-Dalgarno Helix 
#>pdb|1VSA|WW Chain w, Crystal Structure Of A 70s Ribosome-Trna Complex Reveals 
#>pdb|3CW1|VV Chain v, Crystal Structure Of Human Spliceosomal U1 Snrnp

	def self.correct_pdb_accession_nos
		BlastResult.where(BlastResult.arel_table[:seq_name].matches("pdb|%")).find_each do |b|
			seq_name_parts = b.seq_name.split('|')
			suffix=seq_name_parts[2].split()[0]	#	some are 2 chars
			new_seq_name = "#{seq_name_parts[1]}_#{suffix}"
			puts b.accession
			puts new_seq_name
			b.update_column( :accession, new_seq_name )
			b.index
		end
		Sunspot.commit
	end

	def ancestors
		@ancestors ||= ( node.try(:ancestors) || [] )
	end

	validates_presence_of :accession, :bitscore, :contig_name, :contig_length,
		:contig_description, :expect, :file_name, :gaps, :gaps_percent,
		:identities, :identities_percent, :score, :seq_name, :seq_length, :strand

	include ActiveRecordSunspotter::Sunspotability

	add_sunspot_column( :id, :type => :integer, :default => true )
	add_sunspot_column( :file_name, :facetable => true, :default => true )
	add_sunspot_column( :accession, :default => true )
	add_sunspot_column( :name, :facetable => true,
		:meth => ->(s){ s.names.scientific.first || 'NULL?' } )
#
#	I changed this to double, but then the facets went away?????
#		(that's because the name of the column changed and was therefore empty.)
#	Will have to change to double and then reindex if really want it.
#
#	Seems floats only really go down to 1e-50 ish
#
	add_sunspot_column( :expect, :default => true, :facetable => true, :type => :double,
		:range => {
			:log   => true,
			:start => -250,
			:stop  => 0,
			:step  => 10
		} )


#
#	May want to index the node left and right?  All of the ancestors really slows down indexing.
#

	add_sunspot_column( :gi, :type => :integer,
		:meth => ->(s){ s.identifier.try(:gi) })
	add_sunspot_column( :parent_taxid, :type => :integer,
		:meth => ->(s){ s.node.try(:parent_taxid) })
	add_sunspot_column( :taxid, :type => :integer,
		:meth => ->(s){ s.identifier.try(:taxid) })
	add_sunspot_column( :node_left, :type => :integer,
		:meth => ->(s){ s.node.try(:left) })
	add_sunspot_column( :node_right, :type => :integer,
		:meth => ->(s){ s.node.try(:right) })




	#	NOTE index gi or taxid to show NULLs, but can't really facet on this.  Too many!
	add_sunspot_column( :identifier_found, :facetable => true,
		:meth => ->(s){ ( s.identifier.present? ) ? 'Yes' : 'No' } )

	#	NOTE also, some taxids extracted from the nt database, don't exist in the TaxDump data??
	add_sunspot_column( :name_found, :facetable => true,
		:meth => ->(s){ ( s.name.present? ) ? 'Yes' : 'No' } )
	add_sunspot_column( :node_found, :facetable => true,
		:meth => ->(s){ ( s.node.present? ) ? 'Yes' : 'No' } )



	add_sunspot_column( :strand, :facetable => true, :default => true )

#	add_sunspot_column( :ancestor_0, :facetable => true,
#		:meth => ->(s){ s.ancestors[0].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_1, :facetable => true,
#		:meth => ->(s){ s.ancestors[1].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_2, :facetable => true,
#		:meth => ->(s){ s.ancestors[2].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_3, :facetable => true,
#		:meth => ->(s){ s.ancestors[3].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_4, :facetable => true,
#		:meth => ->(s){ s.ancestors[4].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_5, :facetable => true,
#		:meth => ->(s){ s.ancestors[5].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_6, :facetable => true,
#		:meth => ->(s){ s.ancestors[6].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_7, :facetable => true,
#		:meth => ->(s){ s.ancestors[7].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_8, :facetable => true,
#		:meth => ->(s){ s.ancestors[8].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_9, :facetable => true,
#		:meth => ->(s){ s.ancestors[9].try(:scientific_name) } )
#
#	add_sunspot_column( :ancestor_10, :facetable => true,
#		:meth => ->(s){ s.ancestors[10].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_11, :facetable => true,
#		:meth => ->(s){ s.ancestors[11].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_12, :facetable => true,
#		:meth => ->(s){ s.ancestors[12].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_13, :facetable => true,
#		:meth => ->(s){ s.ancestors[13].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_14, :facetable => true,
#		:meth => ->(s){ s.ancestors[14].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_15, :facetable => true,
#		:meth => ->(s){ s.ancestors[15].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_16, :facetable => true,
#		:meth => ->(s){ s.ancestors[16].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_17, :facetable => true,
#		:meth => ->(s){ s.ancestors[17].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_18, :facetable => true,
#		:meth => ->(s){ s.ancestors[18].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_19, :facetable => true,
#		:meth => ->(s){ s.ancestors[19].try(:scientific_name) } )
#
#	add_sunspot_column( :ancestor_20, :facetable => true,
#		:meth => ->(s){ s.ancestors[20].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_21, :facetable => true,
#		:meth => ->(s){ s.ancestors[21].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_22, :facetable => true,
#		:meth => ->(s){ s.ancestors[22].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_23, :facetable => true,
#		:meth => ->(s){ s.ancestors[23].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_24, :facetable => true,
#		:meth => ->(s){ s.ancestors[24].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_25, :facetable => true,
#		:meth => ->(s){ s.ancestors[25].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_26, :facetable => true,
#		:meth => ->(s){ s.ancestors[26].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_27, :facetable => true,
#		:meth => ->(s){ s.ancestors[27].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_28, :facetable => true,
#		:meth => ->(s){ s.ancestors[28].try(:scientific_name) } )
#	add_sunspot_column( :ancestor_29, :facetable => true,
#		:meth => ->(s){ s.ancestors[29].try(:scientific_name) } )
#
##	most are the same up to 21.
##
##irb(main):007:0> Node.group(:depth).count
##   (1339.8ms)  SELECT COUNT(*) AS count_all, depth AS depth FROM `nodes` GROUP BY depth
##=> {1=>1, 2=>5, 3=>38, 4=>1400, 5=>26355, 6=>32991, 7=>22328, 8=>38868, 9=>236408, 10=>79115, 11=>60032, 12=>12322, 13=>13901, 14=>32491, 15=>16721, 16=>35179, 17=>43427, 18=>32563, 19=>38500, 20=>29764, 21=>35103, 22=>47494, 23=>53705, 24=>9528, 25=>13095, 26=>27662, 27=>27447, 28=>20617, 29=>13825, 30=>18762, 31=>24345, 32=>18277, 33=>8812, 34=>6420, 35=>2079, 36=>4626, 37=>4037, 38=>1564, 39=>2556, 40=>261, 41=>19}
#
#	add_sunspot_column( :ancestors, :facetable => true, :multiple => true,
#		:meth => ->(s){ s.ancestors.collect{|a| a.scientific_name } } )

	#	defaults are just string and orderable.  All others are false.
	add_sunspot_column( :contig_length, :type => :integer )
	add_sunspot_column( :bitscore, :type => :float )	#	~ 47.3 - 2141.0
	add_sunspot_column( :score, :type => :integer )	#	~ 25 - 1159
	add_sunspot_column( :identities )	#	ratio <= 1. 100/100, 999/1029
	add_sunspot_column( :identities_percent, :type => :integer,
		:facetable => true,
		:range => {
			:start => 0,
			:stop  => 100,
			:step  => 5
		} )
	add_sunspot_column( :gaps )	#	ratio <= 1.  0/100, 98/1700
	add_sunspot_column( :gaps_percent, :type => :integer,
		:facetable => true,
		:range => {
			:start => 0,
			:stop  => 100,
			:step  => 5
		} )

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

