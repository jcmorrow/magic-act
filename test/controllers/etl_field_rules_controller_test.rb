require 'test_helper'

class EtlFieldRulesControllerTest < ActionController::TestCase
  setup do
    @etl_field_rule = etl_field_rules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:etl_field_rules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create etl_field_rule" do
    assert_difference('EtlFieldRule.count') do
      post :create, etl_field_rule: { active: @etl_field_rule.active, extract_field: @etl_field_rule.extract_field, load_field: @etl_field_rule.load_field, transformation: @etl_field_rule.transformation }
    end

    assert_redirected_to etl_field_rule_path(assigns(:etl_field_rule))
  end

  test "should show etl_field_rule" do
    get :show, id: @etl_field_rule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @etl_field_rule
    assert_response :success
  end

  test "should update etl_field_rule" do
    patch :update, id: @etl_field_rule, etl_field_rule: { active: @etl_field_rule.active, extract_field: @etl_field_rule.extract_field, load_field: @etl_field_rule.load_field, transformation: @etl_field_rule.transformation }
    assert_redirected_to etl_field_rule_path(assigns(:etl_field_rule))
  end

  test "should destroy etl_field_rule" do
    assert_difference('EtlFieldRule.count', -1) do
      delete :destroy, id: @etl_field_rule
    end

    assert_redirected_to etl_field_rules_path
  end
end
