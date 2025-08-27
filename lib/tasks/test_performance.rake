namespace :test do
  desc "Run performance tests"
  task :performance do
    $LOAD_PATH << "test"
    Rails.env = "test"
    test_files = Dir[Rails.root.join("performance_test/**/*_test.rb")]
    puts "Running performance tests..."
    test_files.each { |file| require file }
    require "active_support/testing/autorun"
  end
end
