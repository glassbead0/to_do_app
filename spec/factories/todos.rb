# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :todo do
    name { Faker::Hacker.verb }
    done false
  end
end
