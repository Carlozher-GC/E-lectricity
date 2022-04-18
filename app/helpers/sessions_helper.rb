module SessionsHelper
    # Returns true if the session was created successfully, false otherwise
    def create_session
        return false unless @user.enabled

        session[:user_id] = @user.try(:id)
        session[:access_time] = Time.zone.now.to_i
        true
    end

    def current_user
        return nil if session[:user_id].blank?

        User.find(session[:user_id])
    end
end