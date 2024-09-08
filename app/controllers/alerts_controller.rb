class AlertsController < ApplicationController
  before_action :set_topic, only: [ :create, :unexpired_for_topic ]
  before_action :set_user, only: [ :create, :user_unread_and_unexpired ]

  def create
    type = params[:type] || "InformativeAlert"
    expiration_time = params[:expiration_time]

    AlertSenderService.new(
      topic: @topic,
      message: params[:message],
      type: type,
      expiration_time: expiration_time,
      specific_user: @user
    ).call

    render json: { success: true, message: "Alert sent successfully" }, status: :created
  rescue ActiveRecord::RecordNotFound => e
    render json: { success: false, message: e.message }, status: :not_found
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  def unexpired_for_topic
    render json: @topic.alerts.unexpired.order_by_priority, status: :ok
  end

  def mark_as_read
    alert = Alert.find(params[:id])

    if alert.update(read: true)
      render json: { success: true, message: "Alert marked as read" }, status: :ok
    else
      render json: { success: false, message: "Failed to mark alert as read" }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "Alert not found" }, status: :not_found
  end

  private

  def set_topic
    @topic = Topic.find(params[:topic_id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "Topic not found" }, status: :not_found
  end

  def set_user
    @user = User.find(params[:user_id]) if params[:user_id]
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "User not found" }, status: :not_found
  end
end
