FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
    username { Faker::Internet.unique.username(specifier: Faker::Name.first_name) }
  end
end