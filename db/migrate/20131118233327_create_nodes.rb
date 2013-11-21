class CreateNodes < ActiveRecord::Migration
	def change
		create_table :nodes do |t|
			#	id is taxid
			#	parent_id is parent_taxid
			t.integer :parent_id
			t.integer :lft
			t.integer :rgt
			t.integer :depth
			t.integer :children_count, :default => 0
			t.string :rank
		end
		add_index :nodes, :parent_id
	end
end
