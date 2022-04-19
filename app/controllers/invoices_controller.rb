require 'errors'
require 'constants'

class InvoicesController < ApplicationController
    before_action :set_invoice, only: %i[show edit update]

    include InvoicesHelper

    def create
        
    end

    def new
        if params[:invoice].present?
            begin
                render json: { success: 'true', invoice: read_invoice, fields_by_type: INVOICE_FIELDS_BY_TYPES }
            rescue StandardError => e
                render json: { success: 'false', reason: READ_INVOICE_ERROR, details: e }
            end
        else
            render json: { success: 'false', reason: BAD_PARAMETERS }
        end
    end

    def show; end

    def index
        @invoices = Invoice.where(user_id: params[:user_id])
    end

    def edit; end

    def update

    end

    private

    def set_invoice
        @invoice = Invoice.find(params[:invoice_id])
    end

    def read_invoice
        if is_json?(params[:invoice].original_filename)
            translate_invoice(parse_invoice(params[:invoice]))
        end
    end
end