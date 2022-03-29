class InvoicesController < ApplicationController
    # before_action :set_invoice, only %i[show edit update]

    def create
        
    end

    def new

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
end