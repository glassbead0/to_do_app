require 'rails_helper'

feature 'multiple lists' do
  scenario 'log in and be on default list' do
    @user = FactoryGirl.create(:user, password: 'somePassword', password_confirmation: 'somePassword')

    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'somePassword'
    click_button 'Log in'

    expect(List.find_by(name: 'Default', user_id: @user.id)).to_not eq(nil)

    fill_in 'New item', with: 'belongs to default'
    click_link 'Add'
    fill_in 'New item', with: 'also belongs to default'
    click_link 'Add'

    expect(page).to have_text 'belongs to default'
    expect(page).to have_text 'also belongs to default'

  end



  scenario 'add a new list' do
    @user = FactoryGirl.create(:user, password: 'somePassword', password_confirmation: 'somePassword')

    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: 'somePassword'
    click_link 'Log in'

    expect(List.find_by(name: 'Default', user_id: @user.id)).to_not eq(nil)

    fill_in 'New item', with: 'belongs to default'
    click_link 'Add'
    fill_in 'New item', with: 'also belongs to default'
    click_link 'Add'

    expect(page).to have_text 'belongs to default'
    expect(page).to have_text 'also belongs to default'
    click_link 'New List'

    fill_in 'List name', with: 'Work Stuff'
    click_link 'Create'

    expect(page).to_not have_text 'belongs to default'
    expect(page).to_not have_text 'also belongs to default'

    fill_in 'New item', with: 'belongs to work stuff'
    click_link 'Add'
    fill_in 'New item', with: 'belongs to work stuff too'
    click_link 'Add'

    expect(page).to have_text 'belongs to work stuff'
    expect(page).to have_text 'belongs to work stuff too'

    click_link 'Default'

    expect(page).to have_text 'belongs to default'
    expect(page).to have_text 'also belongs to default'
    expect(page).to_not have_text 'belongs to work stuff'
    expect(page).to_not have_text 'belongs to work stuff too'

    click_link 'Work Stuff'

    expect(page).to_not have_text 'belongs to default'
    expect(page).to_not have_text 'also belongs to default'
    expect(page).to have_text 'belongs to work stuff'
    expect(page).to have_text 'belongs to work stuff too'

  end
end
