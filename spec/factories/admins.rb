FactoryBot.define do
  factory :admin, class: "Account::Admin" do
    id { 1 }
    email { 'admin@example.com' }
    password { "password"}
    password_confirmation { "password" }
  end
end
