require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest

  test "#create creates a notification" do
    assert_difference 'Notification.count' do
      post "/notification", params: { did: '6125551234', token: '1234', platform: 'android'}
      assert_response :ok
      assert_equal 'ok', JSON.parse(response.body)['status']
    end
  end

  test "#create creates only 1 notification per did/token pair" do
    assert_difference 'Notification.count' do
      5.times do
        post "/notification", params: { did: '6125551234', token: '1234', platform: 'android'}
        assert_response :ok
        assert_equal 'ok', JSON.parse(response.body)['status']
      end
    end
  end

  test "#create fails when missing params" do
    assert_no_difference 'Notification.count' do
      post "/notification", params: { token: '1234', platform: 'android'}
      assert_response :bad_request
      assert_equal 'missing params', JSON.parse(response.body)['status']
      post "/notification", params: { did: '6125551234', platform: 'android'}
      assert_response :bad_request
      assert_equal 'missing params', JSON.parse(response.body)['status']
      post "/notification", params: { did: '6125551234', token: '1234' }
      assert_response :bad_request
      assert_equal 'missing params', JSON.parse(response.body)['status']
    end
  end

  test "index replies with error without a did" do
    get "/notification"
    assert_response :ok
    assert_equal 'no did specified', response.body
  end

  test "index does nothing with an unregistered did" do
    get "/notification", params: { did: 'not_registered' }
    assert_response :ok
    assert_equal 'ok', response.body
  end

  test "index sends a notification with android reg" do
    RestClient.expects(:post).once
    get "/notification", params: { did: '6135551234' }
    assert_response :ok
    assert_equal 'ok', response.body
  end

  test "index does nothing with an iphone registered did" do
    get "/notification", params: { did: '6135559876' }
    assert_response :ok
    assert_equal 'ok', response.body
  end

  test "index sends a notification once per android reg" do
    RestClient.expects(:post).twice
    get "/notification", params: { did: '2222222222' }
    assert_response :ok
    assert_equal 'ok', response.body
  end

  test "index sends a legacy notification" do
    RestClient.expects(:get).once
    NotificationsController.any_instance.expects(:legacy_did).returns('1234')
    get "/notification", params: { did: '1234' }
    assert_response :ok
  end

end
