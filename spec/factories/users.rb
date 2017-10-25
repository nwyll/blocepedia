FactoryBot.define do
  factory :user do
    email "user@bloc.io"
    password 'password'
    password_confirmation 'password'
    role "standard"
  end
end