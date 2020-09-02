# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :test_field,
          String,
          null: false,
          description: 'An example field added by the generator'

    # field :new_job_application,
    #       mutation: Mutations::NewJobApplication

    field :new_job_application,
          JobApplicationType,
          null: false do
            argument :candidateId, Integer, required: true
            argument :jobPostingId, Integer, required: true
            argument :isActive, String, required: true
          end

    def test_field
      'Hello World'
    end

    def new_job_application(candidateId: nil, jobPostingId: nil, isActive: nil)
      JobApplication.create!(
        candidate_id: candidateId,
        job_posting_id: jobPostingId,
        is_active: isActive
      )
    end
  end
end
