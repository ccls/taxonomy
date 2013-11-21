class BlastResult < ActiveRecord::Base
	attr_accessible :accession, :bitscore, :expect, :gaps, :gaps_percent, :identities, :identities_percent, :len, :query, :result, :score, :strand
end
