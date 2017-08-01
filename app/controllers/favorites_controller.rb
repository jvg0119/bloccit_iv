class FavoritesController < ApplicationController
  before_action :require_sign_in

  def create
    post = Post.find(params[:post_id])
    favorite = post.favorites.new(user: current_user)

    if favorite.save
      flash[:notice] = "Post favrited"
    else
      flash[:error] = "Favoriting failed."
    end
    redirect_to [post.topic, post] # post show page
  end

  def destroy
    post = Post.find(params[:post_id])
    favorite = post.favorites.find(params[:id])
    if favorite.destroy
      flash[:notice] = "You Unfavorited this post."
    #  redirect_to [post.topic, post] # post show page
    else
      flash[:error] = "There was an error favoriting this post. Please try again."
    #  redirect_to [post.topic, post] # post show page
    end
    redirect_to [post.topic, post]
  end


end
