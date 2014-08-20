require 'rails_helper'

RSpec.describe "todos/new", :type => :view do
  before(:each) do
    assign(:todo, Todo.new(
      :name => "MyString",
      :done => false
    ))
  end

  it "renders new todo form" do
    render

    assert_select "form[action=?][method=?]", todos_path, "post" do

      assert_select "input#todo_name[name=?]", "todo[name]"

      assert_select "input#todo_done[name=?]", "todo[done]"
    end
  end
end
