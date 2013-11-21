class CreateBlastResults < ActiveRecord::Migration
	def change
		create_table :blast_results do |t|
			t.string :query
			t.integer :len
			t.string :result
			t.integer :bitscore
			t.integer :score
			t.string :expect
			t.string :identities
			t.integer :identities_percent
			t.string :gaps
			t.integer :gaps_percent
			t.string :strand
			t.string :accession
		end
	end
end
