require 'rails_helper'

RSpec.describe "lists/show", :type => :view do
  before(:each) do
    @list = assign(:list, List.create!(
      :name => "Name",
      :user_id => "User"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/User/)
  end
end
