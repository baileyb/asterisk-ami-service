require 'spec_helper'

describe "extensions/show" do
  before(:each) do
    @extension = assign(:extension, stub_model(Extension))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
