class NotificationsController < ApplicationController
  protect_from_forgery except: [:create, :show]

  def create
    reg = params.permit(:did, :token, :platform)
    if reg[:did].present? && reg[:token].present? && reg[:platform].present?
      Notification.create_or_update(reg)
      render json: { status: 'ok' }
    else
      render json: { status: 'missing params' }, status: :bad_request
    end
  end

  def show
    reg = params.permit(:did)
    if reg[:did].present?
      sent_notifications = Notification.where(did: reg[:did]).order(last_registered_at: :desc).map(&:send_notification)
      if reg[:did] == legacy_did
        Notification.legacy_notify(reg[:did])
      end
      render plain: 'ok'
    else
      render plain: 'no did specified'
    end
  end

  protected
  def legacy_did
    ENV['NOTIFY_LEGACY_DID']
  end
end
