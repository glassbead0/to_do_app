require 'rails_helper'
require 'spec_helper'

describe 'admin role' do
  scenario 'user can mark self as admin' do
    @user = FactoryGirl.create(:user)
    @todo = FactoryGirl.create(:todo, user_id: @user.id)

    visit new_user_session_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password

    click_button 'Log in'

    expect(page).to have_text "Signed in successfully."
    expect(page).to have_text "#{@todo.name}"
    expect(page).to_not have_text "edit"

    click_link "#{@user.email}"

    fill_in 'Current password', with: @user.password
    check 'Admin'

    click_button 'Update'

    expect(page).to have_text "#{@todo.name}"
    expect(page).to have_link('edit')

  end
end

