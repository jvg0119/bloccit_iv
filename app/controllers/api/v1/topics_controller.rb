class Api::V1::TopicsController < Api::V1::BaseController
  before_action :authenticate_user, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show]

  def index
    topics = Topic.all
    render json: topics, status: 200
  end

  def show
    topic = Topic.find(params[:id])
    render json: topic, status: 200
  end

  def update
    topic = Topic.find(params[:id])
    if topic.update_attributes(topic_params)
      render json: topic, status: 200
    else
      render json: { error: "Topic update failed", status: 400 }, status: 400
    end
  end

  # def update
  #   user = User.find(params[:id])
  #   if user.update_attributes(user_params)
  #     render json: user, status: 200
  #   else
  #     render json: { error: "User update failed", status: 400 }, status: 400
  #   end
  # end


  def create
    topic = Topic.new(topic_params)
    if topic.valid?
      topic.save
      render json: topic, status: 200
    else
      render json: { error: "Topic is invalid", status: 400 }, status: 400
    end
  end

  def destroy
    topic = Topic.find(params[:id])
    if topic.destroy
      render json: { message: "Topic destroyed", status: 200 }, status: 200
      # response.body = { message: "Topic destroyed", status: 200 }   .to_json
    else
      render json: { error: "Error deleting topic", status: 400 }, status: 400
    end
  end

  private
  def topic_params
    params.require(:topic).permit(:name, :description)
  end

end
