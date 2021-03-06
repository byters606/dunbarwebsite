class SessionsController < ApplicationController
 
  def new
  end

  def create
    if params[:session] != nil
      user = User.find_by(username: params[:session][:username].downcase)
      if user && user.authenticate(params[:session][:password])
        if user.activated?
          log_in user
          flash[:info] = "Welcome #{user.username}!"
          redirect_to root_path
        else
          message  = "Account not activated. "
          message += "Check your email for the activation link."
          flash[:danger] = message
          redirect_to root_url
        end
      else
        flash.now[:danger] = 'Invalid username/password combination'
        render 'new'
      end
    else
      flash.now[:danger] = 'Something went wrong. Please try again.'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:info] = 'You have successfully logged out!'
    redirect_to root_path
  end
  
end
