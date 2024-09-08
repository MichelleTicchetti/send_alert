class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy, :mark_all_alerts_as_read ]

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
    alerts = @user.alerts

    alerts = alerts.unread if params[:unread].present?
    alerts = alerts.expired if params[:expired].present?
    alerts = alerts.unexpired if params[:unexpired].present?

    render json: alerts, status: :ok
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
    @user.subscribe_to!(params[:topic_id])
    render json: { success: true, message: "User subscribed to topic successfully" }, status: :ok
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  def unsubscribe_from_topic
    @user.unsubscribe_from!(params[:topic_id])
    render json: { success: true, message: "User unsubscribed to topic successfully" }, status: :ok
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "User not found" }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
