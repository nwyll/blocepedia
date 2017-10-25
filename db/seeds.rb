require 'faker'

5.times do 
  User.create!(
    email:    Faker::Internet.email,
    password: Faker::Internet.password,
    role:     'standard'
    )
end
standard_users = User.where(role: 'standard')

5.times do 
  User.create!(
    email:    Faker::Internet.email,
    password: Faker::Internet.password,
    role:     'premium'
    )
end
premium_users = User.where(role: 'premium')

10.times do
  Wiki.create!(
    user:     standard_users.sample,
    title:    Faker::Hipster.sentence,
    body:     Faker::Lorem.paragraph,
    private:  false
    )
end

10.times do
  Wiki.create!(
    user:     premium_users.sample,
    title:    Faker::Hipster.sentence,
    body:     Faker::Lorem.paragraph,
    private:  Faker::Boolean.boolean
    )
end

standard_member = User.create!(
  email:      'standard_member@test.com',
  password:   'helloworld',
  role:       'standard'
)

premium_member = User.create!(
  email:      'premium_member@test.com',
  password:   'helloworld',
  role:       'premium'
)

admin = User.create!(
  email:      'admin@test.com',
  password:   'helloworld',
  role:       'admin'
)

puts "Seeds finished"
puts "#{standard_users.count} standard users created"
puts "#{premium_users.count} premium users created"
puts "#{User.where(role: 'admin').count} admins created"
puts "#{Wiki.count} topics created"

