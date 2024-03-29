class UsersController < ApplicationController
    skip_before_action :authenticated?, only: %i[new create]
    before_action :set_user, only: %i[show edit update]

    include SessionsHelper

    def create
        @user = User.new(user_params)
        @user.enabled = true
        if @user.save
            if create_session
                redirect_to('/#/contracts')
            else
                redirect_to(login_path(error: ACCOUNT_BLOCKED_ERROR))
            end
        else
            render 'new'
        end
    end

    def new
        @user = User.new
        @user.role = User.roles[:customer]
    end

    def show
        if @user.present?
            render json: @user.as_json(except: [:encrypted_password])
        end
    end

    def current_user
        render json: User.find(session[:user_id]).as_json(except: [:encrypted_password])
    end

    def index
        @users = User.all
    end

    def edit; end

    def update

    end

    # GET /user_countries
    def countries
        users = User.all
        users = users.where("country LIKE ?", "%#{params[:query]}%") if params[:query].present?
        render json: {
            countries: users.pluck(:country).uniq.compact
        }
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:role,
                                     :first_name,
                                     :last_name,
                                     :username,
                                     :email,
                                     :zip_code,
                                     :street,
                                     :phone,
                                     :enabled,
                                     :preferences,
                                     :encrypted_password,
                                     :encrypted_password_confirmation,
                                     :birthday,
                                     :country)
    end

end