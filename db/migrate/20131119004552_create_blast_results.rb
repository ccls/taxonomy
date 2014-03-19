class CreateBlastResults < ActiveRecord::Migration
	def change
		create_table :blast_results do |t|
			t.string :file_name
			t.string :contig_name
			t.string :contig_description
			t.integer :contig_length
			t.string :seq_name
			t.integer :seq_length
#			t.decimal :bitscore, :precision => 8, :scale => 2
			t.float :bitscore
			t.integer :score
			#	float worked for most, but less than ~1e-38 get converted to 0
			#	double seems to extend that down to ~2e-308, and I haven't seen any that low.
#			t.double :expect
#	rails doesn't have a method for double, but float with limit 53 seems to work
#	for some reason, ":limit => 53" isn't copied into the schema.rb
#		fortunately, I don't really ever use it.
#	https://github.com/rails/rails/issues/14135

#	activerecord-4.0.4/lib/active_record/connection_adapters/abstract_mysql_adapter.rb
#	class ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter::Column < ConnectionAdapters::Column
#		def extract_limit(sql_type)
#			...
#			when /^double/i;   53		#	add this to the case block
#			...
#		end
#	end

			t.float :expect, :limit => 53
			t.string :identities
			t.integer :identities_percent
			t.string :gaps
			t.integer :gaps_percent
			t.string :strand
			t.string :accession_prefix
			t.string :accession
		end
		add_index :blast_results, :file_name
		add_index :blast_results, :accession
	end
end

__END__

defaults for decimal are 10 and 0 which means it'd just be an integer!!!!!

