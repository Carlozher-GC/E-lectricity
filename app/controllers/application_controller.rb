require 'json'

require 'errors'
require 'constants'

class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    protect_from_forgery prepend: true

    before_action :authenticated?

    def authenticated?
        update_access_time and return true unless expired_session?

        redirect_to(logout_path(error: SESSION_EXPIRED_ERROR))
    end

    private

    # Returns true if the user has been inactive for 30 minutes or session is not present at all
    def expired_session?
        session[:access_time].blank? || ((Time.zone.now.to_i - session[:access_time].to_i > SESSION_LENGTH_IN_SECONDS))
    end

    def update_access_time
        session[:access_time] = Time.zone.now.to_i
    end
end
