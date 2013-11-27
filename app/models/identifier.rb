class Identifier < ActiveRecord::Base
	attr_accessible :accession, :gi, :taxid
	has_many :names, :foreign_key => :taxid, :primary_key => :taxid
	has_one  :node , :foreign_key => :taxid, :primary_key => :taxid
end
