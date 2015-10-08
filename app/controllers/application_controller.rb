class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
   before_action :allow_cross_origin_requests

   def preflight
       render nothing: true
   end

   private
     def allow_cross_origin_requests
      p "hello" * 100
       headers['Access-Control-Allow-Origin'] = '*'
       headers['Access-Control-Request-Method'] = '*'
       headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
       headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
       headers['Access-Control-Max-Age'] = '1728000'
     end
end
