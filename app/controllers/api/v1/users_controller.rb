class Api::V1::UsersController < Api::V1::BaseController
  before_action :authenticate_user # finds user based on token passed
  before_action :authorize_user # ensures user is an admin

  def show
    user = User.find(params[:id])
    render json: user, status: 200
  end

  def index
    users = User.all
    render json:  users, status: 200
  end

  def update
    user = User.find(params[:id])
    if user.update_attributes(user_params)
      render json: user, status: 200
    else
      render json: { error: "User update failed", status: 400 }, status: 400
    end
  end

  def create
    user = User.new(user_params)
    if user.valid?
      user.save!
      render json: user, status: 201
    else
      render json: { error: "User is invalid", status: 400}, status: 400 # 400 Bad Request
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :role)
  end

end
