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
		add_index :nodes, :lft, :unique => true
		add_index :nodes, :rgt, :unique => true
	end
end
__END__

   (5721.4ms)  CREATE UNIQUE INDEX `index_nodes_on_lft` ON `nodes` (`lft`)
   (5647.1ms)  CREATE UNIQUE INDEX `index_nodes_on_rgt` ON `nodes` (`rgt`)
