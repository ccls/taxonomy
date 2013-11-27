class Node < ActiveRecord::Base
	attr_accessible :taxid, :parent_taxid, :rank
#	attr_accessible :parent_id, :rank

	has_many :names, :primary_key => :taxid, :foreign_key => :taxid

	#	Alias Attributes may work on the rail's side, but won't be
	#		used in any database calls.
#	alias_attribute :taxid, :id
#	alias_attribute :parent_taxid, :parent_id


	#	Now that this is done, why do I need this gem.
	#	Seems like I just needed the nested set infrastructure
	#	This just defines the associations 
	#	has_many :children and belongs_to :parent
	#	which I can do.  And I won't be modifying
	#	the tree at all so seems unnecessary.
	#	And if I do remove it, all of the taxid to id
	#	and parent_taxid to parent_id changes I made
	#	were for naught!  ERRRRRRR!
	#	May need to bring in some of the methods, as needed.
	#	counter_cache may also be a pointless definition
	#		if we won't be modifying these.  Simply setting
	#		the value when built should be good enough.
#	acts_as_nested_set :counter_cache => true

	has_many :children,
		:class_name => 'Node',
#		:foreign_key => :parent_id,
		:foreign_key => :parent_taxid,
		:primary_key => :taxid,
		:inverse_of => :parent,
		:order => :lft
		
	belongs_to :parent, 
		:class_name => 'Node',
#		:foreign_key => :parent_id,
		:foreign_key => :parent_taxid,
		:primary_key => :taxid,
		:counter_cache => true,
		:inverse_of => :children

	scope :roots, ->{ where(:parent_taxid => nil) }
#	scope :roots, ->{ where(:parent_id => nil) }

	def ancestors
		Node.where(Node.arel_table[:lft].gt(lft))
			.where(Node.arel_table[:rgt].lt(rgt))
			.order(:lft)
	end

	def siblings
		Node.where(:parent_id => parent_id)
	end

	def descendants
		Node.where(Node.arel_table[:lft].lt(lft))
			.where(Node.arel_table[:rgt].gt(rgt))
			.order(:lft)
	end

	def scientific_name
		names.scientific.first
	end

end

__END__

rubydoc.info/github/rails/arel/master/Arel/Predications
Arel:Predications

- (Object) does_not_match(other)
- (Object) does_not_match_all(others)
- (Object) does_not_match_any(others)
- (Object) eq(other)
- (Object) eq_all(others)
- (Object) eq_any(others)
- (Object) gt(right)
- (Object) gt_all(others)
- (Object) gt_any(others)
- (Object) gteq(right)
- (Object) gteq_all(others)
- (Object) gteq_any(others)
- (Object) in(other)
- (Object) in_all(others)
- (Object) in_any(others)
- (Object) lt(right)
- (Object) lt_all(others)
- (Object) lt_any(others)
- (Object) lteq(right)
- (Object) lteq_all(others)
- (Object) lteq_any(others)
- (Object) matches(other)
- (Object) matches_all(others)
- (Object) matches_any(others)
- (Object) not_eq(other)
- (Object) not_eq_all(others)
- (Object) not_eq_any(others)
- (Object) not_in(other)
- (Object) not_in_all(others)
- (Object) not_in_any(others) 

