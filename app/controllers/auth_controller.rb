class AuthController < ApplicationController
	before_action :authenticate!, except: :login

	# POST /auth/login
	def login
	  @user = User.find_by(email: login_params[:email])
	  if @user&.authenticate(login_params[:password])
			time = Time.now + 24.hours.to_i
			token = jwt_encode(user_id: @user.id)
			render json: { token: token, exp: time.strftime('%d-%m-%Y %H:%M'),
					   email: @user.email }
	  else
			render json: { error: 'bad credentials' }, status: :forbidden
	  end
	end

	private
  
	def login_params
	  params.permit(:email, :password)
	end
end