class Node < ActiveRecord::Base
	attr_accessible :parent_id, :rank

	has_many :names, :foreign_key => :taxid

	#	Alias Attributes may work on the rail's side, but won't be
	#		used in any database calls.
	alias_attribute :taxid, :id
	alias_attribute :parent_taxid, :parent_id


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
		:foreign_key => :parent_id,
		:inverse_of => :parent,
		:order => :lft
		
	belongs_to :parent, 
		:class_name => 'Node',
		:foreign_key => :parent_id,
		:counter_cache => true,
		:inverse_of => :children

	scope :roots, ->{ where(:parent_id => nil) }

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

end

__END__

        # Add callbacks, if they were supplied.. otherwise, we don't want them.
        [:before_add, :after_add, :before_remove, :after_remove].each do |ar_callback|
          has_many_children_options.update(
            ar_callback => acts_as_nested_set_options[ar_callback]
          ) if acts_as_nested_set_options[ar_callback]
        end

        has_many :children, -> { order(quoted_order_column_name) },
                 has_many_children_options
      end


      def acts_as_nested_set_relate_parent!
        belongs_to :parent, :class_name => self.base_class.to_s,
                            :foreign_key => parent_column_name,
                            :counter_cache => acts_as_nested_set_options[:counter_cache],
                            :inverse_of => (:children unless acts_as_nested_set_options[:polymorphic]),
                            :polymorphic => acts_as_nested_set_options[:polymorphic]
      end

      def acts_as_nested_set_default_options
        {
          :parent_column => 'parent_id',
          :left_column => 'lft',
          :right_column => 'rgt',
          :depth_column => 'depth',
          :dependent => :delete_all, # or :destroy
          :polymorphic => false,
          :counter_cache => false
        }.freeze
      end




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
