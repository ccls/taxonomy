class CreateNames < ActiveRecord::Migration
	def change
		create_table :names do |t|
			t.integer :taxid
			t.string :name_txt
			t.string :name_unique
			t.string :name_class
		end
		add_index :names, :name_class
		add_index :names, :taxid
#
#	sadly, this isn't true, as am only using the scientific,
#	could limit the input and then it would be.
#
#		add_index :names, [:taxid, :name_class], :unique => true
	end
end
