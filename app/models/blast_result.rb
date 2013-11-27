class BlastResult < ActiveRecord::Base
	attr_accessible :accession, :bitscore, :contig_name, :contig_length, 
		:contig_description, :expect, :file_name, :gaps, :gaps_percent, 
		:identities, :identities_percent, :score, :seq_name, :seq_length, :strand

	belongs_to :identifier, :foreign_key => :accession, :primary_key => :accession
	has_many :names, :through => :identifier
	has_one  :node , :through => :identifier

	include Sunspotability

	add_sunspot_column( :id, :default => true )
	add_sunspot_column( :file_name, :facetable => true, :default => true )
	add_sunspot_column( :accession, :facetable => true, :default => true )
	add_sunspot_column( :name, :facetable => true, 
		:meth => ->(s){ s.names.scientific.first || 'NULL?' } )
	add_sunspot_column( :expect, :default => true )
	add_sunspot_column( :strand, :facetable => true, :default => true )
	add_sunspot_column( :ancestors, :facetable => true, :multiple => true,
		:meth => ->(s){ s.node.ancestors.collect{|a| a.names.scientific.first } } )

	searchable_plus




#{:file_name=>"small_trinity_non_human_paired.blastn.txt", :contig_name=>"comp1_c0_seq1 len=104 path=[237:0-56 123:57-80 350:81-103]", :contig_length=>"104", :seq_name=>"gb|AC151056.2| Pan troglodytes BAC clone CH251-310D9 from chromosome y, complete sequence", :seq_length=>"135628", :accession=>"AC151056.2", :bitscore=>"58.4", :score=>"31", :expect=>"9e-06", :identities=>"35/37", :identities_percent=>"95", :gaps=>"0/37", :gaps_percent=>"0", :strand=>"Plus/Minus"}
end
