require 'test_helper'

class EtlJobsControllerTest < ActionController::TestCase
  setup do
    @etl_job = etl_jobs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:etl_jobs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create etl_job" do
    assert_difference('EtlJob.count') do
      post :create, etl_job: {  }
    end

    assert_redirected_to etl_job_path(assigns(:etl_job))
  end

  test "should show etl_job" do
    get :show, id: @etl_job
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @etl_job
    assert_response :success
  end

  test "should update etl_job" do
    patch :update, id: @etl_job, etl_job: {  }
    assert_redirected_to etl_job_path(assigns(:etl_job))
  end

  test "should destroy etl_job" do
    assert_difference('EtlJob.count', -1) do
      delete :destroy, id: @etl_job
    end

    assert_redirected_to etl_jobs_path
  end
end
