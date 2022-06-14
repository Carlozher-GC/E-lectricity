require 'errors'
require 'constants'

class ContractsController < ApplicationController
    def index
        render json: { 
            success: 'true',
            contracts: Contract.where(user_id: session[:user_id]),
        }
    end

    def create
        @contract = Contract.new(contract_params)
        @contract.user_id = session[:user_id]
        if @contract.save
            render json: { success: 'true', contract_id: @contract.id }
        else
            render json: { 
                           success: 'false', 
                           reason: CREATE_CONTRACT_ERROR,
                           details: @contract.errors.first.message
                         }
        end
    end

    def attach_image
        if attach_image_params_valid?
            begin
                contract = Contract.find(params[:contract_id])
                contract.images.attach(params[:image])
                render json: {
                    success: 'true',
                    image_path: rails_blob_path(contract.images.last, only_path: true)
                }
            rescue StandardError => e
                render json: { success: 'false', reason: ATTACH_IMAGE_ERROR, details: e }
            end
        else
            render json: { success: 'false', reason: BAD_PARAMETERS }
        end
    end

    def fetch_images
        if params[:contract_id]
            begin
                images_paths = []
                Contract.find(params[:contract_id]).images.each do |image|
                    images_paths << rails_blob_path(image, only_path: true)
                end
                render json: {
                    success: 'true',
                    images_paths: images_paths
                }
            rescue StandardError => e
                render json: { success: 'false', reason: READ_IMAGE_ERROR, details: e }
            end
        else
            render json: { success: 'false', reason: BAD_PARAMETERS }
        end
    end

    private

    def contract_params
        params.require(:contract).permit(
            :name, :start_date, :end_date,
            :company_name, :building_address,
            :building_number, :building_postal_code,
            :building_city, :building_surface
        )
    end

    def attach_image_params_valid?
        return params[:image].present? && params[:contract_id].present?
    end
end