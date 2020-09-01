FactoryBot.define do
  factory :job_posting do
    title { Faker::Company.profession }
    company_name { Faker::Company.name }
    url { "#{Faker::Name.name}.com" }
  end
end
