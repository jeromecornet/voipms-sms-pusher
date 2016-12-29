require 'rest-client'

class Notification < ApplicationRecord

  GCM_HEADERS = {
    Authorization: "key=#{ENV['GCM_KEY']}",
    content_type: :json,
    accept: :json
  }

  def self.create_or_update(params)
    n = Notification.where(did: params[:did], token: params[:token], platform: params[:platform]).first_or_initialize
    n.last_registered_at = Time.now.utc
    n.save!
  end

  def send_notification()
    return false unless platform == 'android'

    RestClient.post('https://gcm-http.googleapis.com/gcm/send',
    {
      "to": token,
      "time_to_live": 86400,
      "collapse_key": "new_message",
      "delay_while_idle": false,
      "data": {
        "message": "receive"
      }
    }.to_json,
    GCM_HEADERS
    )
    true
  end

  def self.legacy_notify(did)
    RestClient.get("http://voipmssms-kourlas.rhcloud.com/sms_callback?did=#{did}")
  end
end
