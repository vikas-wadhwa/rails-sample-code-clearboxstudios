require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { hours_estimate: @task.hours_estimate, rate_actual: @task.rate_actual, rate_estimate: @task.rate_estimate, description: @task.description, end: @task.end, staff_id: @task.staff_id, staff_rate_actual: @task.staff_rate_actual, staff_rate_estimate: @task.staff_rate_estimate, start: @task.start, status: @task.status, title: @task.title, type: @task.type }
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    put :update, id: @task, task: { hours_estimate: @task.hours_estimate, rate_actual: @task.rate_actual, rate_estimate: @task.rate_estimate, description: @task.description, end: @task.end, staff_id: @task.staff_id, staff_rate_actual: @task.staff_rate_actual, staff_rate_estimate: @task.staff_rate_estimate, start: @task.start, status: @task.status, title: @task.title, type: @task.type }
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end
end
