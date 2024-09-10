class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy, :mark_all_alerts_as_read, :alerts, :subscriptions, :subscribe_to_topic, :unsubscribe_from_topic, :mark_all_alerts_as_read, :mark_alert_as_read ]
  before_action :set_topic, only: [ :subscribe_to_topic, :unsubscribe_from_topic ]

  def index
    users = User.all
    render json: users, status: :ok
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: { success: false, message: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :internal_server_error
  end

  def show
    render json: @user, status: :ok
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { success: false, message: @user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :internal_server_error
  end

  def destroy
    @user.destroy
    render json: { success: true, message: "User deleted successfully" }, status: :ok
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  def alerts
    alerts = @user.alerts.order_by_priority

    alerts = alerts.unread if params[:unread] == 'true'
    alerts = alerts.read if params[:unread] == 'false'
    alerts = alerts.expired if params[:expired] == 'true'
    alerts = alerts.unexpired if params[:expired] == 'false'

    render json: alerts, each_serializer: AlertSerializer, status: :ok
  end

  def subscriptions
    render json: @user.subscriptions, status: :ok
  end

  def mark_all_alerts_as_read
    @user.mark_all_alerts_as_read!
    render json: { success: true, message: "All alerts marked as read" }, status: :ok
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  def mark_alert_as_read
    @user.mark_alert_as_read!(params[:alert_id])
    render json: { success: true, message: "Alert marked as read" }, status: :ok
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  def subscribe_to_topic    
    if @user.subscribe_to!(@topic)
      render json: { success: true, message: "User subscribed to topic successfully" }, status: :ok
    else
      render json: { success: false, message: "Failed to subscribe user to topic" }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "User or Topic not found" }, status: :not_found
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  def unsubscribe_from_topic
    if @user.unsubscribe_from!(@topic)
      render json: { success: true, message: "User unsubscribed from topic successfully" }, status: :ok
    else
      render json: { success: false, message: "Failed to unsubscribe user from topic" }, status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "User or Topic not found" }, status: :not_found
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "User not found" }, status: :not_found
  end

  def set_topic
    @topic = Topic.find(params[:topic_id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "Topic not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
