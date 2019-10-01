FactoryBot.define do
  factory :manager, class: "Account::Manager" do
    id { 1 }
    email { 'manager@example.com' }
    password { "password"}
    password_confirmation { "password" }
  end
end
