# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if User.count.zero?
  Faker::Config.locale = :ja

  User.create!(name: "willnet", email_address: "willnet@example.com", password: "password")
  password_digest = BCrypt::Password.create("password", cost: BCrypt::Engine.cost)
  users_attributes = 1.upto(1000).map do |i|
    { name: "willnet#{i}", email_address: "user#{i}@example.com", password_digest: password_digest }
  end
  user_result = User.insert_all(users_attributes)
  user_ids = user_result.rows.flatten
  posts_attributes = 100000.times.map { { title: Faker::Lorem.sentence, body: Faker::Lorem.sentences.join, user_id: user_ids.sample } }
  post_results = []
  posts_attributes.each_slice(1000) do |pa|
    post_results << Post.insert_all(pa)
  end
  post_ids = post_results.map(&:rows).flatten
  comments_attributes = 1000000.times.map { { body: Faker::Lorem.sentences.join, post_id: post_ids.sample, user_id: user_ids.sample } }
  comments_attributes.each_slice(1000) do |ca|
    Comment.insert_all(ca)
  end
end
