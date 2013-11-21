class Node < ActiveRecord::Base
	attr_accessible :parent_id, :rank

	has_many :names, :foreign_key => :taxid

	#	Alias Attributes may work on the rail's side, but won't be
	#		used in any database calls.
	alias_attribute :taxid, :id
	alias_attribute :parent_taxid, :parent_id

	#	add :children_count
	acts_as_nested_set	#	:counter_cache => true

end

__END__
