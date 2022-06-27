# For executing, run "rails runner generate_random_data.rb"
# The script will create <total_users> users (default 5),
# <total_contracts> contracts (default 2),
# and invoices between 2009 and 2021 for every contract.
# Modify those fields for generating the desired amount of data.
# You can also adapt the generated random invoices data at generate_random_invoices_for_a_year
# by modifying the rand(<value>) + <value>

SECONDS_IN_A_YEAR = 365 * 24 * 60 * 60

total_users = 5
total_contracts = 2
initial_year = 2009
end_year = 2021

@countries = ['España', 'Francia', 'Marruecos', 'Senegal', 'Italia', 'Polonia', 'Canadá', 'Argentina']
@companies = ['Endesa', 'Iberdrola', 'Naturgy', 'TotalEnergies', 'Factor Energía']
@cities = ['Agüimes', 'Las Palmas', 'Madrid', 'Barcelona', 'Bilbao', 'París', 'Vecindario', 'Ottawa', 'Montreal', 'Buenos Aires']

def random_date(from)
    to = Time.now - 18 * SECONDS_IN_A_YEAR
    Time.at(from + rand * (to.to_f - from.to_f))
end

def generate_random_user
    user_hash = Time.now.to_f
    {
        role: 1,
        first_name: "random-user-#{user_hash}",
        last_name: "random-user-#{user_hash}",
        username: user_hash,
        email: "user-#{user_hash}@random.com",
        zip_code: "#{rand(99999)}",
        street: "Random street",
        enabled: true,
        encrypted_password: 'tfg',
        encrypted_password_confirmation: 'tfg',
        country: @countries[rand(@countries.length-1)],
        birthday: random_date(Time.now - 100 * SECONDS_IN_A_YEAR)
    }
end

def generate_random_contract(user_id, number)
    {
        name: "contract #{number}",
        start_date: random_date(Time.now - 30 * SECONDS_IN_A_YEAR),
        company_name: @companies[rand(@companies.length-1)],
        building_address: "Random address",
        building_number: "21",
        building_postal_code: "#{rand(99999)}",
        building_city: @cities[rand(@cities.length-1)],
        building_surface: rand(450) + 50,
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
        new_invoice.current_energy_consumption = rand(50000) + 15000
        new_invoice.contracted_power_price = rand(50) + 15
        new_invoice.consumed_energy_price = rand(100) + 25
        new_invoice.total_price = new_invoice.contracted_power_price + new_invoice.consumed_energy_price
        unless new_invoice.save
            puts "The invoice could not be created: #{invoice.errors.inspect}"
            exit
        end
    end
end

total_users.times do
    user = User.new(generate_random_user)

    unless user.save
        puts "The user could not be created: #{user.errors.inspect}"
        exit
    end

    i = 0
    total_contracts.times do
        contract = Contract.new(generate_random_contract(user.id, i))
        unless contract.save
            puts "The contract could not be created: #{contract.errors.inspect}"
            exit
        end
        for year in initial_year..end_year do
            generate_random_invoices_for_a_year(year, contract.id)
        end
        i += 1
    end
end