class UsersController < ApplicationController
    # before_action :set_user, only %i[show edit update]

    def create
            
    end

    def new

    end

    def show; end

    def index
        @users = User.all
    end

    def edit; end

    def update

    end

    private

    def set_user
        @user = User.find(params[:user_id])
    end
end