class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.name = params[:user][:name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      create_session(@user)
      flash[:notice] = "Welcome to bloccit #{@user.name}!"
      redirect_to root_path
    else
      flash[:alert] = "There was an error saving user.Please try again."
      render :new
    end
  end

end
