class AddScientificNameToNodes < ActiveRecord::Migration
	def change
		add_column :nodes, :scientific_name, :string
	end
end
