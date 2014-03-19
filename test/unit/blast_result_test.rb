require 'test_helper'

class BlastResultTest < ActiveSupport::TestCase
	test "factory should work" do
		blast_result = FactoryGirl.create(:blast_result)
	end

	test "expect should get small" do
		blast_result = FactoryGirl.create(:blast_result,:expect => 1e-30)
		blast_result.reload
		assert_equal 1e-30, blast_result.expect
	end

	#	this will fail because the database schema does not preserve the 'limit' option
	test "expect should get really small" do
		blast_result = FactoryGirl.create(:blast_result,:expect => 1e-300)
		blast_result.reload
		assert_equal 1e-300, blast_result.expect
	end

end
