class TopicsController < ApplicationController
  #include LabelsHelper
  before_action :require_sign_in, except: [:index, :show]
  before_action :authorize_user, except: [:index, :show]

  def index
    #@topics = Topic.all
    @topics = Topic.all.visible_to(current_user)
  end

  def show
    @topic = Topic.find(params[:id])
    unless @topic.public || current_user
      flash[:alert] = "You must be signed in to view private topics."
      redirect_to new_session_path
    end
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      @topic.labels = Label.update_labels(params[:topic][:labels])
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
  #  byebug
    @topic.assign_attributes(topic_params)
    if @topic.save
#    if @topic.update_attributes(topic_params) ## this is equivalent to assign_attributes then save
#    but .update_attributes is not equivalent to assign_attributes by themselves
      @topic.labels = Label.update_labels(params[:topic][:labels])
      # after @topic is saved create the label
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

end
