require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:headers) { { "HTTP_X_CURRENT_NETWORK" => "test" } }

  before do
    allow(helper.request).to receive(:headers).and_return(headers)
  end

  context "When current_network header is missing" do
    it "should raise an error" do
      assert_raises(ArgumentError) { helper.current_network }
    end
  end

  context "When current_network is not existing" do
    let(:headers) { { "HTTP_X_CURRENT_NETWORK" => "test" } }
    it "should raise an error" do
      assert_raises(ArgumentError) { helper.current_network }
    end
  end

  context "When current_network header is set" do
    let(:headers) { { "HTTP_X_CURRENT_NETWORK" => "test" } }
    it "should return the current network object" do
      current_network = Network.create(name: "test")
       expect(helper.current_network.name).to eq(current_network.name)
    end
  end
end
