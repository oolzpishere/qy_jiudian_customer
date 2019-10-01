FactoryBot.define do
  factory :user, class: "Account::User" do
    id { 1 }
    email { 'user@example.com' }
    password { "password"}
    password_confirmation { "password" }
  end
end
