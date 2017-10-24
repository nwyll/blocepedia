FactoryBot.define do
  factory :user do
    email "user@bloc.io"
    password 'password'
    role "standard"
  end
end