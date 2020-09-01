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
  end
end
