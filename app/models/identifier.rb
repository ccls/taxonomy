class Identifier < ActiveRecord::Base
	attr_accessible :accession, :gi, :taxid
	has_many :names, :foreign_key => :taxid, :primary_key => :taxid
	has_one  :node , :foreign_key => :taxid, :primary_key => :taxid
	validates_uniqueness_of :accession
	validates_uniqueness_of :gi

#	accession no 3IZT has no entry but is found in blast results
#> grep 3IZT data/accession_gi_taxid.csv 
#3IZT_A,326634209,83333
#3IZT_B,326634210,83333

end
