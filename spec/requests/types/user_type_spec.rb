require 'rails_helper'

RSpec.describe "Types::UserType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }

  let!(:user) { create(:user) }
  
  describe "ViewerType" do
    let(:query) {
      <<-GRAPHQL
        {
          viewer {
            user {
              firstName
              lastName
              email                                          
            }
            posts {
              edges {
                node {
                  id
                  title
                  description
                }
              }
            }
          }
        }
      GRAPHQL
    }

    it "returns a user" do
      post(endpoint, params: { query: query }  )

      binding.pry
      expect(json["viewer"].keys).to eq(%w(user posts))
      expect(json["viewer"]["user"]).to eq(user.id)
      expect(json["viewer"]["posts"]["edges"].count).to eq(8)
    end
  end
end