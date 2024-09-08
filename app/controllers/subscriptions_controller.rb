class SubscriptionsController < ApplicationController
  before_action :set_user
  before_action :set_topic

  def create
    @user.subscribe_to(@topic)
    render json: { success: true, message: "User successfully subscribed to #{@topic.name}" }, status: :ok
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  def destroy
    @user.unsubscribe_from(@topic)
    render json: { success: true, message: "User successfully unsubscribed from #{@topic.name}" }, status: :ok
  rescue StandardError => e
    render json: { success: false, message: e.message }, status: :unprocessable_entity
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "User not found" }, status: :not_found
  end

  def set_topic
    @topic = Topic.find(params[:topic_id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "Topic not found" }, status: :not_found
  end
end
