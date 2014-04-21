class CreateNodes < ActiveRecord::Migration
	def change
		create_table :nodes do |t|
			#	id is taxid
			#	parent_id is parent_taxid
#
#	Now that I am no longer using the awesome_nested_set gem,
#		taxid and parent_taxid could be used again.
#	Just an FYI to clear up any confusion
#
			t.integer :taxid
			t.integer :parent_taxid
			t.integer :lft
			t.integer :rgt
			t.integer :depth
			t.integer :children_count, :default => 0
			t.string :rank
			t.string :scientific_name
		end
		add_index :nodes, :taxid, :unique => true
		add_index :nodes, :parent_taxid
#		add_index :nodes, :parent_id
		add_index :nodes, :lft, :unique => true
		add_index :nodes, :rgt, :unique => true
		add_index :nodes, [:lft,:rgt], :unique => true
	end
end
__END__
