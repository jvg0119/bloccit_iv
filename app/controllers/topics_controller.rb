class TopicsController < ApplicationController

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
    # @posts = @topic.posts.unscoped.ordered_by_reverse_created_at
    # @posts = @topic.posts.unscoped.ordered_by_title
  end

  def new
    @topic = Topic.new
  end

  def create
    # @topic = Topic.new
    # @topic.name = params[:topic][:name]
    # @topic.public = params[:topic][:public]
    # @topic.description = params[:topic][:description]
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
    # @topic.name = params[:topic][:name]
    # @topic.public = params[:topic][:public]
    # @topic.description = params[:topic][:description]
    # if @topic.update_attributes(name: @topic.name, public: @topic.public, description: @topic.description)
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

end
