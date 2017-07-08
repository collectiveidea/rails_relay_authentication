require 'rails_helper'

RSpec.describe "Types::ViewerType", type: "request" do
  let(:endpoint) { "/graphql" }
  let(:json) { JSON.parse(response.body)["data"] }
  let(:user) { create(:user) }
  let!(:viewer) {
    Viewer.new(uuid: user.uuid, role: user.role)    
  }
  let!(:posts) { 3.times.map { create(:post, user: user) } }
  
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
        expect(json["viewer"]["posts"]["edges"].count).to eq(3)

        posts_json = json["viewer"]["posts"]["edges"].map { |edge| edge["node"] }
        expect(posts_json.map { |item| item["id"] }.compact.length).to eq(3)
        expect(posts_json.map { |item| item["title"] }.compact.length).to eq(3)
        expect(posts_json.map { |item| item["description"] }.compact.length).to eq(3)
      end
    end
  end
end