class CreateBlastResults < ActiveRecord::Migration
	def change
		create_table :blast_results do |t|
			t.string :file_name
			t.string :contig_name
			t.string :contig_description
			t.integer :contig_length
			t.string :seq_name
			t.integer :seq_length
			t.decimal :bitscore		#	not always an integer
			t.integer :score
			t.float :expect							#	may want to use decimal or float for this?
			t.string :identities
			t.integer :identities_percent
			t.string :gaps
			t.integer :gaps_percent
			t.string :strand
			t.string :accession
		end
		add_index :blast_results, :file_name
		add_index :blast_results, :accession
	end
end
