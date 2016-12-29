class NotificationController < ApplicationController

  def create
    reg = params.require(:notification).permit(:did, :token, :platform)
    if reg[:did].present? && reg[:token].present? && reg[:platform].present?
      Notification.create_or_update(reg)
      render json: { status: 'ok' }
    else
      render json: { status: 'missing params' }
    end
  end

  def index
    Notification.where(did: params[:did]).order(last_registered_at: :desc).each(&:send_notification)
    render text: 'ok'
  end

end
