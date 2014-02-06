class AddHitOrderToBlastResult < ActiveRecord::Migration
	def change
		add_column :blast_results, :hit_order, :integer
	end
end
