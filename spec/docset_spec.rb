require "spec_helper"

RSpec.describe Docset do
  it "has a version number" do
    expect(Docset::VERSION).not_to be nil
  end
end
