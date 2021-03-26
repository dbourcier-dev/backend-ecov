require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  context "When current_network header is missing" do
    it "should raise an error" do
      assert_raises(ArgumentError) { helper.current_network }
    end
  end

  context "When current_network header is set" do
    let(:headers) { { "HTTP_X_CURRENT_NETWORK" => "test" } }
    it "should return the value of the header" do
      current_network = Network.create(name: "test")
      allow(helper.request).to receive(:headers).and_return(headers)
      expect(helper.current_network.name).to eq(current_network.name)
    end
  end
end
