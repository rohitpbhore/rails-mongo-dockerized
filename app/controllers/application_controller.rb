class ApplicationController < ActionController::API
    include ApiResponders
    include ApiRescuable
    include JwtWebToken
    include PaginateableController

    def routing_error
      respond_with_error("Routing Error", :not_found)
    end
  
    private
  
    def authenticate!
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      @decoded = jwt_decode(header)
      @current_user = User.find(@decoded[:user_id])
    	rescue Mongoid::Errors::DocumentNotFound => e
      	render json: { message: 'not found' }, status: 404
    	rescue JWT::DecodeError => e
      	render json: { errors: e.message }, status: :forbidden
    end
end