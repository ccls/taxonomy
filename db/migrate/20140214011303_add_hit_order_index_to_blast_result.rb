class AddHitOrderIndexToBlastResult < ActiveRecord::Migration
	def change
		add_index :blast_results, :hit_order
	end
end
