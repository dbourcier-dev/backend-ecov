require "rails_helper"

RSpec.describe "Get the full list of users", type: :request do
  let(:headers) { {"HTTP_X_CURRENT_NETWORK" => Base64.strict_encode64("Toulouse") } }
  let(:toulouse) { Network.create(name: "Toulouse") }
  let(:paris) { Network.create(name: "Paris") }
  let(:david) { { email: "david@email.com", network: toulouse } }
  let(:peter) { { email: "peter@email.com", network: paris } }
  let(:request_params) {
      {
        query:
        <<-GRAPHQL
          query{
            users {
              id
              email
            }
          }
        GRAPHQL
      }
    }
  before do
    User.create([david, peter])
  end

  subject { post "/graphql", params: request_params, headers: headers }
  it "should return all the users of the current network" do
    subject

    expect(response).to be_successful
    expect(response.body).to include(david[:email])
    expect(response.body).to_not include(peter[:email])
  end

  context "when the network doesn't exitst" do
    let(:headers) { {"HTTP_X_CURRENT_NETWORK" => Base64.strict_encode64("Nantes") } }
    it "should raise an error" do
      assert_raises(ArgumentError) {subject}
    end
  end
end
