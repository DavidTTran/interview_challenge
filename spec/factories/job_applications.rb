FactoryBot.define do
  factory :job_application do
    association :candidate, factory: :candidate
    association :job_posting, factory: :job_posting

    trait :active do
      is_active { true }
    end

    trait :inactive do
      is_active { false }
    end
  end
end
