require 'spec_helper'

describe "extensions/index" do
  before(:each) do
    assign(:extensions, [
      stub_model(Extension),
      stub_model(Extension)
    ])
  end

  it "renders a list of extensions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
