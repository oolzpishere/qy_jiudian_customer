FactoryBot.define do
  factory :user, class: "Account::User" do
    id { 1 }
    email { 'user@example.com' }
    phone { 12345123451 }
    password { "password"}
    password_confirmation { "password" }
    otp_secret_key {Account::User.otp_random_secret}
    factory :user_with_identifies do
      after(:create) do |user, evaluator|
        create(:identify, user_id: user.id)
      end
    end
  end

  factory :identify, class: "Account::Identify" do
    provider {"wechat"}
    uid {"o5m8i049i6bQTKEiXYJEZAIwUTjU"}
    unionid {"unionid"}
  end
end
