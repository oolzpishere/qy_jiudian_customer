module Account
  class User < ApplicationRecord
    self.table_name = 'users'
    has_many :identifies, dependent: :destroy
    has_many :orders


    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :validatable, authentication_keys: [:login]

   def email_required?
       false
   end

   validates_presence_of :email, if: :phone_blank?
   validates_presence_of :phone, if: :email_blank?
# https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address

    def phone_blank?
      phone.blank?
    end

    def email_blank?
      email.blank?
    end
# <10 login with phone and email
    attr_writer :login

    def login
     @login || self.phone || self.email
    end

    validates_format_of :phone, with: /\A[0-9_+]*\z/
    validate :validate_phone

    def validate_phone
      if User.where(email: phone).exists?
        errors.add(:phone, :invalid)
      end
    end

    # function to handle user's login via email or phone
    def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(phone) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        if conditions[:phone].nil?
          where(conditions).first
        else
          where(phone: conditions[:phone]).first
        end
      end
    end
# <!10

  end
end
