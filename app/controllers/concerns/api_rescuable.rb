module ApiRescuable
	extend ActiveSupport::Concern
  
	included do
		rescue_from Mongoid::Errors::DocumentNotFound, with: :handle_record_not_found
	end
  
	private
  
	def handle_record_not_found(exception)
		respond_with_error(exception.message, :not_found)
	end
end