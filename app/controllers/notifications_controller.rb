class NotificationsController < ApplicationController

  def create
    reg = params.permit(:did, :token, :platform)
    if reg[:did].present? && reg[:token].present? && reg[:platform].present?
      Notification.create_or_update(reg)
      render json: { status: 'ok' }
    else
      render json: { status: 'missing params' }
    end
  end

  def show
    reg = params.permit(:did)
    if reg[:did].present?
      Notification.where(did: reg[:did]).order(last_registered_at: :desc).each(&:send_notification)
      render plain: 'ok'
    else
      render plain: 'no did specified'
    end
  end

end
