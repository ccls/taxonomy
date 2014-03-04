
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
		:contig_description, :expect, :file_name, :gaps, :gaps_percent, :hit_order,
		:identities, :identities_percent, :score, :seq_name, :seq_length, :strand

	#
	#	Need a way to separate the accession number from the version in a way
	#	that if we have NC_020081.2 in the blast result and on NC_020081.1 in the 
	#	identifiers, or vice versa, it will work.
	#
	belongs_to :identifier, :foreign_key => :accession, :primary_key => :accession
#	has_many :names, :through => :identifier
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

#  Node.where(:scientific_name => "Viruses").first (taxid 10239)
#		lft: 2011260, rgt: 2248987
# 
#  Node.where(:scientific_name => "Bacteria").order('depth ASC').first    # two actually!!! (taxid 2)
#		lft: 191, rgt: 670200
# 
#  Node.where(:scientific_name => "Homo Sapiens").first.taxid  (really deep) (taxid 9606)
#  => 9606
#  Node.where(:taxid => 9606).first.parent.parent.parent.parent.parent.parent.parent.parent.taxid
#  => 9443
#  Primates (taxid 9443)
#		lft: 1338132, rgt: 1339757

	#	These ranges WILL NEED UPDATED if the nodes are reimported.
	add_sunspot_column( :node_left, :type => :integer,
		:label => 'Taxonomy',
		:facetable => true,
		:ranges => [		
#			{ :name => 'Virus',    :range => 2..231301 },
#			{ :name => 'Bacteria', :range => 247411..880040 },
#			{ :name => 'Primate',  :range => 2132877..2134498 }
			{ :name => 'Virus',    :range => 2011260...2248987 },
			{ :name => 'Bacteria', :range => 191...670200 },
			{ :name => 'Primate',  :range => 1338132...1339757 }
		],
		:meth => ->(s){ s.node.try(:lft) })

	add_sunspot_column( :id, :type => :integer, :default => true )
	add_sunspot_column( :file_name, :facetable => true, :default => true )
	add_sunspot_column( :hit_order, :type => :integer, :facetable => true, :default => true )
	add_sunspot_column( :accession, :default => true )
	add_sunspot_column( :name, :facetable => true,
		:meth => ->(s){ s.node.try(:scientific_name) || 'NULL?' } )
#		:meth => ->(s){ s.names.scientific.first || 'NULL?' } )
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

	add_sunspot_column( :gi, :type => :integer,
		:meth => ->(s){ s.identifier.try(:gi) },
		:link_to => ->(s){ "http://www.ncbi.nlm.nih.gov/nuccore/#{s.identifier.try(:gi)}" })
	add_sunspot_column( :parent_taxid, :type => :integer,
		:meth => ->(s){ s.node.try(:parent_taxid) })
	add_sunspot_column( :taxid, :type => :integer,
		:meth => ->(s){ s.identifier.try(:taxid) })
	add_sunspot_column( :node_depth, :type => :integer,
		:meth => ->(s){ s.node.try(:depth) })


	add_sunspot_column( :node_right, :type => :integer,
		:meth => ->(s){ s.node.try(:rgt) })

	add_sunspot_column( :identifier_found, :facetable => true,
		:meth => ->(s){ ( s.identifier.present? ) ? 'Yes' : 'No' } )

	#	NOTE also, some taxids extracted from the nt database, don't exist in the TaxDump data??
	#	don't know how this ever worked.  There is no "name" attribute or association.
	#	must've been using the sunspot column name?
#	add_sunspot_column( :name_found, :facetable => true,
#		:meth => ->(s){ ( s.name.present? ) ? 'Yes' : 'No' } )	

	add_sunspot_column( :node_found, :facetable => true,
		:meth => ->(s){ ( s.node.present? ) ? 'Yes' : 'No' } )

	add_sunspot_column( :strand, :facetable => true, :default => true )

	#	defaults are just string and orderable.  All others are false.
	add_sunspot_column( :contig_name )
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

