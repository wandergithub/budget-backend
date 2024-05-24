# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'


# Clear existing data
Transaction.delete_all

# Define the start date
start_date = Date.today - 1.year

# Generate data for each day of the past year
(start_date..Date.today).each do |date|
  # Create a random number of posts per day
  rand(1..5).times do
    Transaction.create!(
      name: Faker::Lorem.sentence(word_count: 1),
      value: Faker::Number.between(from: -10000, to: 10000),
      created_at: date,
      updated_at: date
    )
  end
end

puts "Seeded a year's worth of data."