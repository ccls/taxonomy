class AddTaxidNameClassIndexToNames < ActiveRecord::Migration
	def change
		add_index :names, [:taxid, :name_class]
	end
end
