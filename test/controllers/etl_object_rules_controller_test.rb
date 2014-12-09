require 'test_helper'

class EtlObjectRulesControllerTest < ActionController::TestCase
  setup do
    @etl_object_rule = etl_object_rules(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:etl_object_rules)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create etl_object_rule" do
    assert_difference('EtlObjectRule.count') do
      post :create, etl_object_rule: { active: @etl_object_rule.active, extract_field: @etl_object_rule.extract_field, load_field: @etl_object_rule.load_field }
    end

    assert_redirected_to etl_object_rule_path(assigns(:etl_object_rule))
  end

  test "should show etl_object_rule" do
    get :show, id: @etl_object_rule
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @etl_object_rule
    assert_response :success
  end

  test "should update etl_object_rule" do
    patch :update, id: @etl_object_rule, etl_object_rule: { active: @etl_object_rule.active, extract_field: @etl_object_rule.extract_field, load_field: @etl_object_rule.load_field }
    assert_redirected_to etl_object_rule_path(assigns(:etl_object_rule))
  end

  test "should destroy etl_object_rule" do
    assert_difference('EtlObjectRule.count', -1) do
      delete :destroy, id: @etl_object_rule
    end

    assert_redirected_to etl_object_rules_path
  end
end
