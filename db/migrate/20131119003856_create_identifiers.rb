class CreateIdentifiers < ActiveRecord::Migration
	def change
		create_table :identifiers do |t|
			t.string  :accession
			t.integer :gi
			t.integer :taxid
		end
		add_index :identifiers, :accession, :unique => true
		add_index :identifiers, :gi, :unique => true
		add_index :identifiers, :taxid
	end
end
