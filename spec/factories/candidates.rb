FactoryBot.define do
  factory :candidate do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
  end
end

def candidate_with_applications(count = 3)
  FactoryBot.create(:candidate) do |candidate|
    FactoryBot.create_list(:job_application, count, candidate: candidate)
  end
end
