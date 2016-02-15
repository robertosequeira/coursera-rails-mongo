require 'test_helper'

class Api::RacesControllerTest < ActionController::TestCase
  setup do
    @api_race = api_races(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:api_races)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create api_race" do
    assert_difference('Api::Race.count') do
      post :create, api_race: {  }
    end

    assert_redirected_to api_race_path(assigns(:api_race))
  end

  test "should show api_race" do
    get :show, id: @api_race
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @api_race
    assert_response :success
  end

  test "should update api_race" do
    patch :update, id: @api_race, api_race: {  }
    assert_redirected_to api_race_path(assigns(:api_race))
  end

  test "should destroy api_race" do
    assert_difference('Api::Race.count', -1) do
      delete :destroy, id: @api_race
    end

    assert_redirected_to api_races_path
  end
end
