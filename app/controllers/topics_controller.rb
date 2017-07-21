class TopicsController < ApplicationController
  before_action :require_sign_in, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show, :edit, :update]
  before_action :moderator_user, only: [:edit, :update]
    # for the assignment cp 40 Authorization
    # added before_action :moderator_user
    # made sure it did not conflict with authorize_user

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      flash[:notice] = "The topic was saved successfully!"
      redirect_to @topic
    else
      flash[:error] = "Error creating topic. Please try again."
      render :new
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update

    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      flash[:notice] = "The topic was udated successfully!"
      redirect_to @topic
    else
      flash[:error] = "Error updating the topic. Please try again."
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.destroy
      flash[:notice] = "The topic was deleted!"
      redirect_to topics_url
    end
  end

  private
  def topic_params
    params.require(:topic).permit(:name, :public, :description)
  end

  def authorize_user
    unless current_user.admin?
      flash[:alert] = "You must be an admin to do that."
      redirect_to topics_path
    end
  end

  def moderator_user
    unless current_user.moderator? || current_user.admin?
      flash[:alert] = "You are not authorize to do this action."
      redirect_to topics_path
    end
  end

end
