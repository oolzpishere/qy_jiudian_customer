FactoryBot.define do
  factory :user, class: "Account::User" do
    id { 1 }
    email { 'user@example.com' }
    phone { 12345123451 }
    password { "password"}
    password_confirmation { "password" }
    otp_secret_key {Account::User.otp_random_secret}
  end
end
