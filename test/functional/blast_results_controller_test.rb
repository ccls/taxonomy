require 'test_helper'

class BlastResultsControllerTest < ActionController::TestCase
  setup do
    @blast_result = blast_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:blast_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create blast_result" do
    assert_difference('BlastResult.count') do
      post :create, blast_result: { accession: @blast_result.accession, bitscore: @blast_result.bitscore, expect: @blast_result.expect, gaps: @blast_result.gaps, gaps_percent: @blast_result.gaps_percent, identities: @blast_result.identities, identities_percent: @blast_result.identities_percent, len: @blast_result.len, query: @blast_result.query, result: @blast_result.result, score: @blast_result.score, strand: @blast_result.strand }
    end

    assert_redirected_to blast_result_path(assigns(:blast_result))
  end

  test "should show blast_result" do
    get :show, id: @blast_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @blast_result
    assert_response :success
  end

  test "should update blast_result" do
    put :update, id: @blast_result, blast_result: { accession: @blast_result.accession, bitscore: @blast_result.bitscore, expect: @blast_result.expect, gaps: @blast_result.gaps, gaps_percent: @blast_result.gaps_percent, identities: @blast_result.identities, identities_percent: @blast_result.identities_percent, len: @blast_result.len, query: @blast_result.query, result: @blast_result.result, score: @blast_result.score, strand: @blast_result.strand }
    assert_redirected_to blast_result_path(assigns(:blast_result))
  end

  test "should destroy blast_result" do
    assert_difference('BlastResult.count', -1) do
      delete :destroy, id: @blast_result
    end

    assert_redirected_to blast_results_path
  end
end
