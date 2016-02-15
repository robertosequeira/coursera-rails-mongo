require 'test_helper'

class Api::RacersControllerTest < ActionController::TestCase
  setup do
    @api_racer = api_racers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_racers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_racer" do
    assert_difference('Api::Racer.count') do
      post :create, api_racer: {  }
    end

    assert_redirected_to api_racer_path(assigns(:api_racer))
  end

  test "should show api_racer" do
    get :show, id: @api_racer
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_racer
    assert_response :success
  end

  test "should update api_racer" do
    patch :update, id: @api_racer, api_racer: {  }
    assert_redirected_to api_racer_path(assigns(:api_racer))
  end

  test "should destroy api_racer" do
    assert_difference('Api::Racer.count', -1) do
      delete :destroy, id: @api_racer
    end

    assert_redirected_to api_racers_path
  end
end
