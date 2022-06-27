# For executing, run "rails runner generate_specific_data.rb"
# The script will create one user, one contracts, and invoices between 2009 and 2021 for the contracts.

SECONDS_IN_A_YEAR = 365 * 24 * 60 * 60

initial_year = 2009
end_year = 2021

@countries = ['España', 'Francia', 'Marruecos', 'Senegal', 'Italia', 'Polonia', 'Canadá', 'Argentina']
@companies = ['Endesa', 'Iberdrola', 'Naturgy', 'TotalEnergies', 'Factor Energía']
@cities = ['Agüimes', 'Las Palmas', 'Madrid', 'Barcelona', 'Bilbao', 'París', 'Vecindario', 'Ottawa', 'Montreal', 'Buenos Aires']

def random_date(from)
    to = Time.now - 18 * SECONDS_IN_A_YEAR
    Time.at(from + rand * (to.to_f - from.to_f))
end

def generate_specific_user
    user_hash = Time.now.to_f
    {
        role: 1,
        first_name: "Usuario 2",
        last_name: "User 2",
        username: 'Usuario 2',
        email: "usuario-2@electricity.com",
        zip_code: "#{rand(99999)}",
        street: "Random street",
        enabled: true,
        encrypted_password: 'tfg',
        encrypted_password_confirmation: 'tfg',
        country: 'España',
        birthday: random_date(Time.now - 100 * SECONDS_IN_A_YEAR)
    }
end

def generate_specific_contract(user_id)
    {
        name: "Casa en Las Palmas",
        start_date: Date.parse('01-01-2008'),
        company_name: 'Iberdrola',
        building_address: "Calle del mal despertar",
        building_number: "21",
        building_postal_code: "#{rand(99999)}",
        building_city: 'Las Palmas',
        building_surface: 95,
        user_id: user_id
    }
end

def generate_random_invoices_for_a_year(year, contract_id)
    for month in 1..12 do
        new_invoice = Invoice.first.dup
        new_invoice.contract_id = contract_id
        new_invoice.invoice_number = "#{contract_id}-#{year}-#{month}"
        new_invoice.start_billing_date = Date.parse("01-#{month}-#{year}")
        new_invoice.end_billing_date = Date.parse("28-#{month}-#{year}")
        new_invoice.invoice_release_date = Date.parse("28-#{month}-#{year}")
        new_invoice.current_energy_consumption = rand(70000) + 30000
        new_invoice.contracted_power_price = rand(80) + 15
        new_invoice.consumed_energy_price = rand(200) + 40
        new_invoice.total_price = new_invoice.contracted_power_price + new_invoice.consumed_energy_price
        unless new_invoice.save
            puts "The invoice could not be created: #{invoice.errors.inspect}"
            exit
        end
    end
end

user = User.new(generate_specific_user)

unless user.save
    puts "The user could not be created: #{user.errors.inspect}"
    exit
end

contract = Contract.new(generate_specific_contract(user.id))
unless contract.save
    puts "The contract could not be created: #{contract.errors.inspect}"
    exit
end
for year in initial_year..end_year do
    generate_random_invoices_for_a_year(year, contract.id)
end
