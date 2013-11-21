class CreateNames < ActiveRecord::Migration
	def change
		create_table :names do |t|
			t.integer :taxid
			t.string :name_txt
			t.string :name_unique
			t.string :name_class
		end
		add_index :names, :taxid
	end
end
