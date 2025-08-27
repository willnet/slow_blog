require_relative 'blog_content_generator'

if User.count.zero?
  puts "Creating users..."
  User.create!(name: "willnet", email_address: "willnet@example.com", password: "password")
  password_digest = BCrypt::Password.create("password", cost: 4)
  users_attributes = 1.upto(1000).map do |i|
    name = BlogContentGenerator.generate_name
    { name: name, email_address: "#{name}@example.com", password_digest: password_digest }
  end
  user_result = User.insert_all(users_attributes)
  user_ids = user_result.rows.flatten

  puts "Creating posts..."
  posts_attributes = 100000.times.map { { title: BlogContentGenerator.generate_title, body: BlogContentGenerator.generate_body, user_id: user_ids.sample, status: rand < 0.9 ? 0 : 1, view_count: rand(0..10000) } }
  post_results = []
  posts_attributes.each_slice(1000) do |pa|
    post_results << Post.insert_all(pa)
  end
  post_ids = post_results.map(&:rows).flatten

  puts "Creating tags and assigning to posts..."
  # Create all possible tags first to avoid repeated queries
  all_tags = BlogContentGenerator::TAGS.map do |tag_name|
    Tag.find_or_create_by(name: tag_name)
  end

  # Assign tags to posts with intentionally inefficient approach
  # This creates a performance issue where we could use pluck instead
  post_ids.each_slice(1000) do |batch_post_ids|
    posts_tags_attributes = []
    batch_post_ids.each do |post_id|
      # Assign 1-3 random tags to each post
      selected_tags = all_tags.sample(rand(1..3))
      selected_tags.each do |tag|
        posts_tags_attributes << { post_id: post_id, tag_id: tag.id }
      end
    end

    # Use insert_all to avoid individual INSERT statements
    Tagging.insert_all(posts_tags_attributes) if posts_tags_attributes.any?
  end

  puts "Creating comments..."
  comments_attributes = 1000000.times.map { { body: BlogContentGenerator.generate_comment, post_id: post_ids.sample, user_id: user_ids.sample } }
  comments_attributes.each_slice(1000) do |ca|
    Comment.insert_all(ca)
  end

  puts "Seed data creation completed!"
end
