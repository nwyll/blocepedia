FactoryGirl.define do
  factory :wiki do
    title "Test Title"
    body "test body"
    private false
    user
  end
end