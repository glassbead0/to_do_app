require 'rails_helper'
require 'spec_helper'

describe 'todo list' do
  scenario 'can add a todo item' do
    @user = FactoryGirl.create(:user)

    visit '/'
    click_link 'Login'
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    # click_button 'Log in'

    # fill_in 'Name', with: 'get me done!'
    # click_button 'Add'
    #
    # expect(page).to have_text('get me done!')
  end

  scenario 'can mark an item as done' do
    todo = FactoryGirl.create(:todo)




  end


end
