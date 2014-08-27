require 'rails_helper'

RSpec.describe "lists/index", :type => :view do
  before(:each) do
    assign(:lists, [
      List.create!(
        :name => "Name",
        :user_id => "User"
      ),
      List.create!(
        :name => "Name",
        :user_id => "User"
      )
    ])
  end

  it "renders a list of lists" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
  end
end
