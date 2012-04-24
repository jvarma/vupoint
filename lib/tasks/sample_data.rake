namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "jayant varma",
      email: "jayant.1971@gmail.com",
      password: "foobar",
      password_confirmation: "foobar")
    admin.toggle!(:admin)
    User.create!(name: "Example User",
                 email: "user@example.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    99.times do |n|
      name  = Faker::Name.name
      email = "user-#{n+1}@example.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end