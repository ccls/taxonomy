class BlastResult < ActiveRecord::Base
	attr_accessible :accession, :bitscore, :contig_name, :contig_length, 
		:contig_description, :expect, :file_name, :gaps, :gaps_percent, 
		:identities, :identities_percent, :score, :seq_name, :seq_length, :strand

	include Sunspotability

	add_sunspot_column( :accession, :facetable => true, :default => true )


#	add sunspot


#{:file_name=>"small_trinity_non_human_paired.blastn.txt", :contig_name=>"comp1_c0_seq1 len=104 path=[237:0-56 123:57-80 350:81-103]", :contig_length=>"104", :seq_name=>"gb|AC151056.2| Pan troglodytes BAC clone CH251-310D9 from chromosome y, complete sequence", :seq_length=>"135628", :accession=>"AC151056.2", :bitscore=>"58.4", :score=>"31", :expect=>"9e-06", :identities=>"35/37", :identities_percent=>"95", :gaps=>"0/37", :gaps_percent=>"0", :strand=>"Plus/Minus"}
end
