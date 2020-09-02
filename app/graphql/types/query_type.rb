# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :hello_world, # name of method
          String, # Type the data will be
          null: false, # If it can ever return a null value
          description: 'An example field added for your reference!' # Optional Description

    field :all_candidates,
          [CandidateType],
          null: false,
          description: 'Returns all candidates in database'

    field :candidate,
          [CandidateType],
          null: true,
          description: 'Returns a single candidate given valid ID' do
            argument :id, Integer, required: true
          end

    field :job_applications,
          [JobApplicationType],
          null: false,
          description: 'Returns a single job application given valid ID' do
            argument :id, Integer, required: false
            argument :is_active, Boolean, required: false
          end

    def hello_world
      'Hello World - This is your Interview Challenge!\nGood luck.'
    end

    def all_candidates
      Candidate.all
    end

    def candidate(filter)
      Candidate.where(filter)
    end

    def job_applications(filter)
      JobApplication.where(filter)
    end
  end
end
