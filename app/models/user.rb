class User < ApplicationRecord
    has_many :contracts, dependent: :destroy

    before_save { email.downcase! }

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :birthday, presence: true
    validates :country, presence: true
    validates :encrypted_password, presence: true

    validates_confirmation_of :encrypted_password

    validate :email_format_valid?
    validate :phone_format_valid?

    enum roles: %i[admin customer]

    def email_format_valid?
        errors.add(:email, :format_not_valid, message: 'Email format is not valid') if email !~ /\A[\w.+-]+@\w+\.\w+\Z/
    end

    def phone_format_valid?
        return if phone.blank?

        errors.add(:phone, :format_not_valid, message: 'Phone format is not valid') if phone !~ /\A\+\d{11}\Z/
    end
end
