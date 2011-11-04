class UsersController < ApplicationController
  def new
    @title = "Sign Up"
    @user = User.new
  end
  def create
    @user = User.new(params[:user])

    if @user.valid?
      @user.save
      flash[:success] = "You've successfully registered!"
      redirect_to @user
      return
    end

    if not verify_recaptcha
       @user.errors.add(:base,"Recaptcha is incorrect")
    end
    
    @title = "Sign Up"
    render 'new'
  end
  def show
    @user = User.find(params[:id])
  end
  def verify
    @title = "Sign In"
  end
end