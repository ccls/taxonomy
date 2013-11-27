class ApplicationController < ActionController::Base
	protect_from_forgery

	#	Flash error message and redirect
	def access_denied( 
			message="You don't have permission to complete that action.", 
			default=root_path )
		session[:return_to] = request.url unless params[:format] == 'js'
		flash[:error] = message
		redirect_to default
	end

end
