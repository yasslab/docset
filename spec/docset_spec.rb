require "spec_helper"

RSpec.describe Docset do
  it "has a version number" do
    expect(Docset::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
