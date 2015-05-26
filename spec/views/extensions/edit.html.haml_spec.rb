require 'spec_helper'

describe "extensions/edit" do
  before(:each) do
    @extension = assign(:extension, stub_model(Extension))
  end

  it "renders the edit extension form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => extensions_path(@extension), :method => "post" do
    end
  end
end
