class UsersController < ApplicationController
  before_action :set_person, only: [:show]
  before_filter :generate_pin, only: [:create]
  before_action :set_user, only: [:update]


  def new
    @user = User.new
  end


  def create
    @user = User.new(user_params)


    if @user.save
      sign_in @user
      @user.confirm_code = generate_pin
      @user.save

      redirect_to '/confirm', notice: @g_code

    else
      render 'new'

    end
  end

  def update
    @code = params[:pin].to_s
    if signed_in?
      if @code == current_user.confirm_code.to_s
        @user.update_attributes(:confirm => true)
        if @user.save
          sign_out
          flash[:notice] = "Account confirmed successfully"
          redirect_to '/users/new'

        end
      else
        flash[:notice] = "Incorrect code"
        render :confirm
      end
    else
      flash[:notice] = "If you have problems with confirmation, contact the administrator"
      redirect_to root_path
    end
  end


  def generate_pin
    @g_code = rand(10 ** 4)
  end


  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :birthday, :password, :password_confirmation)
  end

  def set_user
    @user = current_user
  end

end

