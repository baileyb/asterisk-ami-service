require 'spec_helper'

describe "extensions/new" do
  before(:each) do
    assign(:extension, stub_model(Extension).as_new_record)
  end

  it "renders new extension form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => extensions_path, :method => "post" do
    end
  end
end
