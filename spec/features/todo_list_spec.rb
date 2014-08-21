require 'rails_helper'
require 'spec_helper'

describe 'todo list' do
  scenario 'can add a todo item' do
    visit todos_path

    click_link 'New Tudu'

    fill_in 'Name', with: 'get me done!'
    click_button 'Add'

    expect(page).to have_text('get me done!')
  end

  scenario 'can mark an item as done' do
    todo = FactoryGirl.create(:todo)

    visit todos_path


  end


end
