require 'rails_helper'
require 'helpers/user_helpers.rb'

feature 'restaurants' do

  include UserSignIn

  context 'no restaurants have been added' do

    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end

  end

  context 'restaurants have been added' do

    before do
      Restaurant.create(name: 'KFC')
    end

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants yet!')
    end

  end

  context 'creating restaurants' do

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      user = build(:user)
      visit '/restaurants'
      sign_up(user.email, user.password)
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'guest cannot add a restaurant' do
       visit '/'
       click_link 'Add a restaurant'
       expect(current_path).to eq '/users/sign_in'
    end

    context 'an invalid restaurant' do

      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        user = build(:user)
        sign_up(user.email, user.password)
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end

    end

  end

  context 'viewing restaurants' do

    let!(:kfc){Restaurant.create(name:'KFC')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

    scenario 'guest can see restaurants' do
      visit '/'
      expect(page).to have_content 'KFC'
    end

  end

  context 'editing restaurants' do

    before {Restaurant.create name: 'KFC'}

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      user = build(:user)
      sign_up(user.email, user.password)
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'
    end

  end

  context 'deleting a restaurant' do

    before {Restaurant.create name: 'KFC'}

    scenario 'removes a restaurant when the user clicks a delete link' do
      visit '/restaurants'
      user = build(:user)
      sign_up(user.email, user.password)
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

  end

end
