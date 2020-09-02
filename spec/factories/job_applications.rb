FactoryBot.define do
  factory :job_application do
    association :job_posting, factory: :job_posting
    candidate

    trait :active do
      is_active { true }
    end

    trait :inactive do
      is_active { false }
    end
  end
end
