module Queries
  RSpec.describe JobApplication, type: :request do
    describe "jobApplications query" do
      it "returns a single job application given id" do
        create_list(:job_application, 2)
        job_application = create(:job_application)

        post '/graphql', params: { query: jobApplications(id: job_application.id) }
        json = JSON.parse(response.body)

        job_application = json["data"]["jobApplications"]

        expect(JobApplication.all.count).to eq(3)

        expect(job_application.count).to eq(1)
        expect(job_application[0]["id"]).to be_truthy
        expect(job_application[0]["jobPostingId"]).to be_truthy
        expect(job_application[0]["candidateId"]).to be_truthy
      end

      it "can sort JobApplications by active status" do
        create(:job_application, :active)
        create(:job_application, :active)
        create(:job_application, :inactive)
        create(:job_application, :inactive)

        post '/graphql', params: { query: activeJobApplications(isActive: true) }
        json = JSON.parse(response.body)

        job_applications = json["data"]["jobApplications"]

        expect(JobApplication.all.length).to eq(4)
        expect(job_applications.length).to eq(2)

        job_applications.each do |job_app|
          expect(job_app["isActive"]).to be true
        end
      end
    end

    def jobApplications(id:)
      <<~GQL
        query {
          jobApplications(id: #{id}) {
            id
            jobPostingId
            candidateId
          }
        }
      GQL
    end

    def activeJobApplications(isActive:)
      <<~GQL
        query {
          jobApplications(isActive: #{isActive}) {
            id
            jobPostingId
            candidateId
            isActive
          }
        }
      GQL
    end

  end
end
