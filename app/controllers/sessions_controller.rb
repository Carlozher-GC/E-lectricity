require 'errors'

class SessionsController < ApplicationController
    skip_before_action :authenticated?, only: %i[new create logout]

    include SessionsHelper

    def new
        @error = params[:error]
        reset_session if expired_session?
    end

    def create
        if correct_credentials?
            if create_session
                redirect_to('/#/invoices')
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

    private

    def correct_credentials?
        return false if params[:email].blank? || params[:password].blank?
        
        @user = User.find_by(email: params[:email])
        @user.present? && @user.encrypted_password == params[:password]
    end
end