require 'errors'

class SessionsController < ApplicationController
    skip_before_action :authenticated?, only: %i[new create logout session_expiracy_time]

    include SessionsHelper

    def new
        @error = params[:error]
        reset_session if expired_session?
    end

    def create
        if correct_credentials?
            if create_session
                redirect_to('/#/contracts')
            else
                redirect_to(login_path(error: ACCOUNT_BLOCKED_ERROR))
            end
        else
            redirect_to(login_path(error: INCORRECT_CREDENTIALS_ERROR))
        end
    end

    def logout
        reset_session
        redirect_to(login_path)
    end

    def session_expiracy_time
        if params[:user_id].present? && session[:user_id] == params[:user_id].to_i
            unless Time.zone.now.to_i - session[:access_time].to_i > SESSION_LENGTH_IN_SECONDS
                render json: {
                    success: 'true', expiracy_time: session[:access_time] + SESSION_LENGTH_IN_SECONDS
                } and return
            end
        end

        render json: {
            success: 'false', reason: SESSION_EXPIRED_ERROR
        }
    end

    private

    def correct_credentials?
        return false if params[:email].blank? || params[:password].blank?
        
        @user = User.find_by(email: params[:email])
        @user.present? && @user.encrypted_password == params[:password]
    end
end