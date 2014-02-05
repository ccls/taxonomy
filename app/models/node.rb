class Node < ActiveRecord::Base
	attr_accessible :taxid, :parent_taxid, :rank

	has_many :names, :primary_key => :taxid, :foreign_key => :taxid

	has_many :children,
		:class_name => 'Node',
		:foreign_key => :parent_taxid,
		:primary_key => :taxid,
		:inverse_of => :parent,
		:order => :lft
		
	belongs_to :parent, 
		:class_name => 'Node',
		:foreign_key => :parent_taxid,
		:primary_key => :taxid,
		:counter_cache => true,
		:inverse_of => :children

	scope :roots, ->{ where(:parent_taxid => nil) }

	def descendants
		Node.where(Node.arel_table[:lft].gt(lft))
			.where(Node.arel_table[:rgt].lt(rgt))
			.order(:lft)
#	seems to speed up individual queries, but indexing all takes twice as long?
#			.from("`nodes` FORCE INDEX (index_nodes_on_lft_and_rgt)")
	end


#[#   ] [  12100/1515945] [  0.80%] [01:44:46] [217:01:27] [      1.92/s]


	def siblings
		Node.where(:parent_id => parent_id)
	end

	def ancestors
		Node.where(Node.arel_table[:lft].lt(lft))
			.where(Node.arel_table[:rgt].gt(rgt))
			.order(:lft)
#	seems to speed up individual queries, but indexing all takes twice as long?
#			.from("`nodes` FORCE INDEX (index_nodes_on_lft_and_rgt)")
	end

	def scientific_name
#		names.scientific.first

#	created scientific_name column now so .......

		if( read_attribute(:scientific_name).blank? )
			self.update_column(:scientific_name, names.scientific.first.to_s)
		end
		read_attribute(:scientific_name)
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

