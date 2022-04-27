require 'errors'
require 'constants'

class InvoicesController < ApplicationController
    before_action :set_invoice, only: %i[show edit update]

    include InvoicesHelper

    def create
        @invoice = Invoice.new(invoice_params)
        @invoice.user_id = session[:user_id]
        if @invoice.save
            render json: { success: 'true', invoice_id: @invoice.id }
        else
            render json: { 
                           success: 'false', 
                           reason: CREATE_INVOICE_ERROR,
                           details: @invoice.errors.first.message
                         }
        end
    end

    def new
        if params[:invoice].present?
            begin
                render json: { 
                               success: 'true',
                               invoice: read_invoice,
                               fields_by_type: INVOICE_FIELDS_BY_TYPE,
                               fields_by_unit: INVOICE_FIELDS_BY_UNIT
                             }
            rescue StandardError => e
                render json: { success: 'false', reason: READ_INVOICE_ERROR, details: e }
            end
        else
            render json: { success: 'false', reason: BAD_PARAMETERS }
        end
    end

    def show; end

    def index
        #@invoices = Invoice.where(user_id: session[:user_id])
        @invoices = Invoice.all
    end

    def edit; end

    def update

    end

    private

    def set_invoice
        @invoice = Invoice.find(params[:invoice_id])
    end

    def invoice_params
        params.require(:invoice).permit(
            :invoice_number, :invoice_reference, :invoice_release_date,
            :start_billing_date, :end_billing_date, :total_billing_days,
            :days_per_year, :last_energy_consumption, :current_energy_consumption,
            :energy_consumption_delta, :contracted_power_price, :consumed_energy_price,
            :subtotal_1, :electricity_tax, :equipment_rental_price,
            :subtotal_2, :total_price, :access_toll_rate,
            :access_toll_price, :marketer_cost_rate, :marketer_cost_price,
            :contracted_power_rate, :access_toll_energy_rate, :access_toll_energy_price,
            :energy_cost_rate, :energy_cost_price, :energy_rate,
            :energy_price, :equipment_price_per_day, :electricity_tax_rate,
            :subtotal_tax_equipment, :normal_tax_rate, :reduced_tax_rate,
            :reduced_tax_price, :total_plus_tax
        )
    end

    def read_invoice
        if is_json?(params[:invoice].original_filename)
            translate_invoice(parse_invoice(params[:invoice]))
        end
    end
end