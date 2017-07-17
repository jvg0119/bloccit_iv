class SponsoredPostsController < ApplicationController

  def show
    @sponsored_post = SponsoredPost.find(params[:id])
  end

  def new
    @topic = Topic.find(params[:topic_id])
    @sponsored_post = SponsoredPost.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @sponsored_post = SponsoredPost.new
    @sponsored_post.title = params[:sponsored_post][:title]
    @sponsored_post.body = params[:sponsored_post][:body]
    @sponsored_post.price = params[:sponsored_post][:price]
    @sponsored_post.topic = @topic
    if @sponsored_post.save
      flash[:notice] = "Sponsored Post was saved successfully!"
      redirect_to([@topic, @sponsored_post])
      #byebug
    else
      flash[:error] = "Error saving Sponsored Post. Please try again."
      render :new
  #    byebug
    end
  end

  def edit
    @sponsored_post = SponsoredPost.find(params[:id])
  end

  def update
    @sponsored_post = SponsoredPost.find(params[:id])
    @sponsored_post.title = params[:sponsored_post][:title]
    @sponsored_post.body = params[:sponsored_post][:body]
    @sponsored_post.price = params[:sponsored_post][:price]

    # if @sponsored_post.update_attributes(title: @sponsored_post.title, body: @sponsored_post.body, price: @sponsored_post.price)
    if @sponsored_post.save
      flash[:notice] = "Sponsored Post was updated successfully!"
      redirect_to [@sponsored_post.topic, @sponsored_post]
    else
      flash[:error] = "Error updating Sponsored Post. Please try again."
      render :edit
    end
  end

  def destroy
    @sponsored_post = SponsoredPost.find(params[:id])
    if @sponsored_post.destroy
      flash[:notice] = "The Sponsored Post was deleted."
      redirect_to @sponsored_post.topic
    end
  end

end
