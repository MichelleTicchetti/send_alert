class TopicsController < ApplicationController
  def index
    topics = Topic.all
    render json: topics, status: :ok
  end

  def create
    topic = Topic.new(topic_params)
    if topic.save
      render json: topic, status: :created
    else
      render json: { success: false, message: topic.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    topic = Topic.find(params[:id])
    topic.destroy
    render json: { success: true, message: "Topic deleted successfully" }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "Topic not found" }, status: :not_found
  end

  private

  def topic_params
    params.require(:topic).permit(:name)
  end
end
