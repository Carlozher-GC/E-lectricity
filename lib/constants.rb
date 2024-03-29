SESSION_LENGTH_IN_SECONDS = 30 * 60

INVOICE_KEYS = {
    'F1': :invoice_number,
    'F2': :invoice_reference,
    'F3': :invoice_release_date,
    'F4': :start_billing_date,
    'F5': :end_billing_date,
    'F6': :total_billing_days,
    'F7': :days_per_year,
    'I1': :last_energy_consumption,
    'I2': :current_energy_consumption,
    'I3': :energy_consumption_delta,
    'H3': :energy_consumption_delta,
    'J1': :contracted_power_price,
    'J2': :consumed_energy_price,
    'J3': :subtotal_1,
    'J4': :electricity_tax,
    'J5': :equipment_rental_price,
    'J8': :subtotal_2,
    'JB': :total_price,
    'K2': :access_toll_rate,
    'K3': :access_toll_price,
    'K4': :marketer_cost_rate,
    'K5': :marketer_cost_price,
    'K6': :contracted_power_rate,
    'K9': :access_toll_energy_rate,
    'KA': :access_toll_energy_price,
    'KB': :energy_cost_rate,
    'KC': :energy_cost_price,
    'KD': :energy_rate,
    'KE': :energy_price,
    'M3': :equipment_price_per_day,
    'N1': :electricity_tax_rate,
    'N3': :subtotal_tax_equipment,
    'N4': :normal_tax_rate,
    'N5': :reduced_tax_price,
    'N6': :reduced_tax_rate,
    'N7': :total_plus_tax
}.freeze

INVOICE_FIELDS_IN_SPANISH = {
    invoice_number: 'Nº de factura',
    invoice_reference: 'Nº de referencia',
    invoice_release_date: 'Fecha de la factura',
    start_billing_date: 'Comienzo de la facturación',
    end_billing_date: 'Término de la facturación',
    total_billing_days: 'Días de facturación',
    days_per_year: 'Días por año',
    last_energy_consumption: 'Consumo de energía previo',
    current_energy_consumption: 'Consumo de energía actual',
    energy_consumption_delta: 'Diferencia de consumo',
    contracted_power_price: 'Coste potencia contratada',
    consumed_energy_price: 'Coste energía consumida',
    subtotal_1: 'Subtotal 1',
    electricity_tax: 'Impuesto electricidad',
    equipment_rental_price: 'Coste del alquiler del equipo',
    subtotal_2: 'Subtotal 2',
    total_price: 'Coste total',
    access_toll_rate: 'Tarifa del peaje',
    access_toll_price: 'Coste del peaje',
    marketer_cost_rate: 'Tarifa del vendedor',
    marketer_cost_price: 'Coste del vendedor',
    contracted_power_rate: 'Tarifa potencia contratada',
    access_toll_energy_rate: 'Tarifa de la energía del peaje',
    access_toll_energy_price: 'Coste de la energía del peaje',
    energy_cost_rate: 'Tasa de coste de la energía',
    energy_cost_price: 'Precio del coste de la energía',
    energy_rate: 'Tasa de energía',
    energy_price: 'Coste de la energía',
    equipment_price_per_day: 'Coste del equipo por día',
    electricity_tax_rate: 'Tasa del impuesto de electricidad',
    subtotal_tax_equipment: 'Subtotal impuestos del equipo',
    normal_tax_rate: 'Tipo impositivo normal',
    reduced_tax_price: 'Precio del impuesto reducido',
    reduced_tax_rate: 'Tipo impositivo reducido',
    total_plus_tax: 'Total más impuestos'
}.freeze

# Any other field not included here will be considered as float
INVOICE_FIELDS_BY_TYPE = {
    'date': %i[invoice_release_date start_billing_date end_billing_date],
    'number': %i[total_billing_days energy_consumption_delta last_energy_consumption current_energy_consumption days_per_year],
    'text': %i[invoice_number invoice_reference normal_tax_rate reduced_tax_rate electricity_tax_rate]
}.freeze

# Any other field not included won´t have a unit assigned
INVOICE_FIELDS_BY_UNIT = {
    '€': %i[energy_price energy_cost_price subtotal_tax_equipment subtotal_2 subtotal_1 total_plus_tax 
            total_price access_toll_energy_price marketer_cost_price reduced_tax_price equipment_price_per_day
            consumed_energy_price equipment_rental_price contracted_power_price access_toll_price electricity_tax],
    '%': %i[normal_tax_rate reduced_tax_rate electricity_tax_rate],
    'kWh': %i[last_energy_consumption current_energy_consumption energy_consumption_delta],
    '€/kWh': %i[access_toll_energy_rate energy_cost_rate],
    '€/kW': %i[marketer_cost_rate access_toll_rate]
}.freeze

INVOICE_FIELDS_BY_SECTION = [
    [
        :invoice_number, :invoice_reference, :invoice_release_date,
        :start_billing_date, :end_billing_date, :total_billing_days, :days_per_year
    ],
    [
        :last_energy_consumption, :current_energy_consumption, :energy_consumption_delta
    ],
    [
        :contracted_power_price, :consumed_energy_price, :subtotal_1,
        :electricity_tax, :equipment_rental_price, :subtotal_2, :total_price
    ],
    [
        :access_toll_rate, :access_toll_price, :marketer_cost_rate,
        :marketer_cost_price, :contracted_power_rate, :access_toll_energy_rate,
        :access_toll_energy_price, :energy_cost_rate, :energy_cost_price,
        :energy_rate, :energy_price
    ],
    [
        :equipment_price_per_day, :electricity_tax_rate, :subtotal_tax_equipment,
        :normal_tax_rate, :reduced_tax_price, :reduced_tax_rate, :total_plus_tax
    ]
].freeze

# Months
MONTHS = {
    'enero': 1,
    'febrero': 2,
    'marzo': 3,
    'abril': 4,
    'mayo': 5,
    'junio': 6,
    'julio': 7,
    'agosto': 8,
    'septiembre': 9,
    'octubre': 10,
    'noviembre': 11,
    'diciembre': 12,
}.freeze