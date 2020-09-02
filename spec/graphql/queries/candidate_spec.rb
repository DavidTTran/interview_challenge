require 'rails_helper'

module Queries
  RSpec.describe Candidate, type: :request do
    describe 'allCandidates query' do
      it "returns all candidates" do
        create_list(:candidate, 3)

        post '/graphql', params: { query: allCandidates }
        json = JSON.parse(response.body)

        candidates = json["data"]["allCandidates"]

        expect(candidates.count).to eq(3)

        candidates.each do |candidate|
          expect(candidate["id"]).to be_truthy
          expect(candidate["firstName"]).to be_truthy
          expect(candidate["lastName"]).to be_truthy
          expect(candidate["email"]).to be_truthy
        end
      end
    end

    describe 'candidate query' do
      it "returns a single candidate given a valid id" do
        create_list(:candidate, 2)
        candidate = create(:candidate)

        post '/graphql', params: { query: candidate(id: candidate.id) }
        json = JSON.parse(response.body)

        response_candidate = json["data"]["candidate"][0]

        expect(response_candidate["id"].to_i).to eq(candidate.id)
        expect(response_candidate["firstName"]).to eq(candidate.first_name)
        expect(response_candidate["lastName"]).to eq(candidate.last_name)
        expect(response_candidate["email"]).to eq(candidate.email)
      end

      it "returns an empty array if candidate ID doesn't exist" do
        create(:candidate)

        post '/graphql', params: { query: candidate(id: 3) }
        json = JSON.parse(response.body)

        expect(json["data"]["candidate"]).to eq([])
      end

      it "returns an error if candidate ID is invalid" do
        create(:candidate)

        post '/graphql', params: { query: candidate(id: "String") }
        json = JSON.parse(response.body)

        expect(json).to have_key("errors")
      end

      it "can return a candidate with associated JobApplications" do
        candidate = candidate_with_applications(3)
        create_list(:job_application, 2)

        post '/graphql', params: { query: candidateWithApplication(id: candidate.id) }
        json = JSON.parse(response.body)
        response_candidate = json["data"]["candidate"][0]

        expect(Candidate.all.count).to eq(3)
        expect(JobApplication.all.count).to eq(5)
        
        expect(response_candidate["id"].to_i).to eq(candidate.id)
        expect(response_candidate["jobApplications"]).to be_truthy
        expect(response_candidate["jobApplications"].count).to eq(3)

        response_candidate["jobApplications"].each do |app|
          expect(app["candidateId"]).to eq(candidate.id)
        end
      end
    end

    def allCandidates
      <<~GQL
        query {
          allCandidates {
            id
            firstName
            lastName
            email
          }
        }
      GQL
    end

    def candidate(id:)
      <<~GQL
        query {
          candidate(id: #{id}) {
            id
            firstName
            lastName
            email
          }
        }
      GQL
    end

    def candidateWithApplication(id:)
      <<~GQL
        query {
          candidate(id: #{id}) {
            id
            firstName
            lastName
            email
            jobApplications {
              id
              candidateId
              jobPostingId
            }
          }
        }
      GQL
    end

  end
end
