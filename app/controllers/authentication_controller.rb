class AuthenticationController < ApplicationController
skip_before_action :authenticate_request
def create
    @user = User.new(user_params)

    if @user.save
      authenticate
    else
      render json: @user.errors, status: :unprocessable_entity
    end
end


	def authenticate 
		command = AuthenticateUser.call(params[:email], params[:password]) 
		if command.success? 
			render json: { auth_token: command.result } 
		else render json: { error: command.errors }, status: :unauthorized 
		end 
	end
 private
    
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.permit(:email, :password,:password_confirmation)
    end
end


