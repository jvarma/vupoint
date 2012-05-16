namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_debates
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Jayant Varma",
                       email:    "jayant.1971@gmail.com",
                       password: "foobar",
                       password_confirmation: "foobar",
                       confirmed_at: Time.now)
  admin.toggle!(:admin)
  50.times do |n|
    name  = Faker::Name.name
    email = "user-#{n+1}@example.com"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password,
                 confirmed_at: Time.now)
  end
end

def make_debates
  users = User.all(limit: 6)
  20.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.debates.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..30]
  followers      = users[10..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end


