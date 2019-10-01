module Account
  class Manager < ApplicationRecord
    self.table_name = 'managers'

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable  :registerable,
    devise :database_authenticatable,
           :recoverable, :rememberable, :validatable
  end
end
