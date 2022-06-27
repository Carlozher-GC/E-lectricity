require 'errors'
require 'constants'

class InvoicesController < ApplicationController
    before_action :set_invoice, only: %i[show update]

    include InvoicesHelper

    def create
        @invoice = Invoice.new(invoice_params)
        @invoice.contract_id = params[:contract_id]
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
                    fields_by_unit: INVOICE_FIELDS_BY_UNIT,
                    fields_by_section: INVOICE_FIELDS_BY_SECTION,
                    fields_in_spanish: INVOICE_FIELDS_IN_SPANISH
                }
            rescue StandardError => e
                render json: { success: 'false', reason: READ_INVOICE_ERROR, details: e }
            end
        else
            render json: { success: 'false', reason: BAD_PARAMETERS }
        end
    end

    def show
        render json: {
            success: 'true',
            invoice: @invoice,
            fields_by_type: INVOICE_FIELDS_BY_TYPE,
            fields_by_unit: INVOICE_FIELDS_BY_UNIT,
            fields_by_section: INVOICE_FIELDS_BY_SECTION,
            fields_in_spanish: INVOICE_FIELDS_IN_SPANISH
        }
    end

    def index
        if params[:contract_id].present?
            render json: { 
                success: 'true',
                invoices: Invoice.where(contract_id: params[:contract_id]),
                fields_by_unit: INVOICE_FIELDS_BY_UNIT,
                months: MONTHS.keys
            }
        else
            render json: { success: 'false', reason: BAD_PARAMETERS }
        end
    end

    # GET /invoices_dataset
    def dataset
        if params[:filter].present? && params[:years].present?
            filter = JSON.parse(params[:filter])
            user_ids = retrieve_matching_user_ids(filter['ageRange'], filter['userCountries'])
            contract_ids = retrieve_matching_contract_ids(
                user_ids,
                filter['contractCompanies'],
                filter['contractCities'],
                filter['startDate'],
                filter['endDate'],
                filter['surfaceRange']
            )
            invoices = retrieve_matching_invoices(
                contract_ids,
                filter['consumedEnergyRange'],
                filter['totalPriceRange'],
                filter['contractedPowerPriceRange'],
                filter['consumedEnergyPriceRange']
            )
            render json: {
                success: 'true',
                dataset: process_dataset(invoices.to_a, params[:years])
            }
        else
            render json: {
                success: 'false',
                reason: BAD_PARAMETERS
            }
        end
    end

    def update
        if @invoice.update(invoice_params)
            render json: { success: 'true' }
        else
            render json: {
                success: 'false',
                reason: UPDATE_INVOICE_ERROR,
                details: @invoice.errors.first.message
            }
        end
    end

    private

    def set_invoice
        @invoice = Invoice.find(params[:id])
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

    def retrieve_matching_user_ids(age_range, user_countries)
        youngest_birthday = Date.today - (age_range[0] * 365)
        oldest_birthday = Date.today - (age_range[1] * 365)
        users = User.where(
            'birthday >= ? AND birthday <= ?',
            oldest_birthday, youngest_birthday
        )
        users = users.where(country: user_countries) if user_countries.length > 0
        users.pluck(:id)
    end

    def retrieve_matching_contract_ids(
        user_ids,
        contract_companies,
        contract_cities,
        start_date,
        end_date,
        surface_range
    )
        contracts = Contract.where(user_id: user_ids)
        contracts = contracts.where(company_name: contract_companies) if contract_companies.length > 0
        contracts = contracts.where(building_city: contract_cities) if contract_cities.length > 0
        contracts = contracts.where('start_date >= ?', start_date) if start_date.present?
        contracts = contracts.where('end_date >= ?', end_date) if end_date.present?
        contracts.where("building_surface BETWEEN #{surface_range[0]} AND #{surface_range[1]}").pluck(:id)
    end
    
    def retrieve_matching_invoices(
        contract_ids,
        consumed_energy_range,
        total_price_range,
        contracted_power_price_range,
        consumed_energy_price_range
    )
        Invoice.where(contract_id: contract_ids).where(
            "current_energy_consumption BETWEEN #{consumed_energy_range[0]} AND #{consumed_energy_range[1]}" +
            " AND total_price BETWEEN #{total_price_range[0]} AND #{total_price_range[1]}" +
            " AND contracted_power_price BETWEEN #{contracted_power_price_range[0]} AND #{contracted_power_price_range[1]}" +
            " AND consumed_energy_price BETWEEN #{consumed_energy_price_range[0]} AND #{consumed_energy_price_range[1]}"
        )
    end

    # Return the dataset for the given filter arranged by year
    def process_dataset(invoices, years)
        dataset = {}
        years.each do |year|
            year_invoices = invoices.filter { |invoice| invoice.start_billing_date.year == year.to_i }
            dataset[year] = format_invoices_dataset(arrange_invoices_by_month(year_invoices))
        end
        dataset
    end

    def arrange_invoices_by_month(year_invoices)
        ordered_year_invoices = []
        for month in 1..12 do
            ordered_year_invoices << year_invoices.filter { |invoice| invoice.start_billing_date.month == month }
        end
        ordered_year_invoices
    end

    # For each field, return the values to show per month
    def format_invoices_dataset(invoices_by_month)
        fields = ['total_price', 'current_energy_consumption', 'contracted_power_price', 'consumed_energy_price']
        formatted_dataset = {}
        fields.each do |field|
            formatted_dataset[field] = []
            invoices_by_month.each do |month_invoices|
                formatted_dataset[field] << calculate_field_average(month_invoices, field)
            end
        end
        formatted_dataset
    end
end