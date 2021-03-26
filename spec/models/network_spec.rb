require 'rails_helper'

RSpec.describe Network, type: :model do
  subject { described_class.new }

  it "should have a valid name" do
    subject.name = "Nantes"
    expect(subject).to be_valid
  end

  it "should not have an empty name" do
    subject.name = ""
    expect(subject).to_not be_valid
  end
end
