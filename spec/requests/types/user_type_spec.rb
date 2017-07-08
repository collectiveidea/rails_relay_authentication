require 'rails_helper'

RSpec.describe "Types::UserType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:user) { create(:user) }
  let!(:viewer) {
    Viewer.new(uuid: user.reload.uuid, role: user.role)    
  }
  
  describe "ViewerType" do
    let(:query) {
      <<-GRAPHQL
        {
          viewer {
            user {
              id
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

    describe "Logged in" do
      before(:each) {
        allow_any_instance_of(Warden::Proxy).to receive(:user).and_return(viewer)
      }

      it "returns a user" do
        post(endpoint, params: { query: query }  )

        expect(json["viewer"].keys).to eq(%w(user posts))
        expect(json["viewer"]["user"]["id"]).to eq(user.uuid)
        #expect(json["viewer"]["posts"]["edges"].count).to eq(8)
      end
    end
  end
end