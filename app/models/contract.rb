class Contract < ApplicationRecord
    belongs_to :user
    has_many :invoices, dependent: :destroy

    has_many_attached :images

    validates :name, presence: true
    validates :start_date, presence: true
    validates :company_name, presence: true
    validates :building_address, presence: true
    validates :building_number, presence: true
    validates :building_postal_code, presence: true
    validates :building_city, presence: true

     # Check that the user doesn´t repeat the name of a contract
     def name_unique?
        if user.contracts.find_by(name: name).present?
            errors.add(:name,
                       :name_repeated,
                       message: 'This contract name already exists')
        end
    end
end
