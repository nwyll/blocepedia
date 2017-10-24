FactoryGirl.define do
  factory :wiki do
    title "Test Title"
    body "test body sufficiently long"
    private false
    user
  end
end