require "application_system_test_case"

class EditUserTest < ApplicationSystemTestCase

    setup do
        @smith = User.create(email: 'smith@gmail.com', first_name: 'Smith', last_name: 'Smith', is_admin: false, password: 'testpassword', password_confirmation: 'testpassword')
        @prof = User.create(email: 'msmucker@gmail.com', first_name: 'Mark', last_name: 'Smucker', is_admin: true, password: 'professor', password_confirmation: 'professor')
    end

    def test_profile_updates_correctly_student
        visit root_url
        login 'smith@gmail.com', 'testpassword'
        click_on "Edit Profile"

        fill_in 'First Name', with: 'John'
        fill_in 'Last Name', with: 'Johnson'

        click_on 'Update Profile'

        assert_text "Profile successfully updated!"
        assert_text "Welcome, John Johnson"
    end

    def test_profile_updates_correctly_instructor
        visit root_url
        login 'msmucker@gmail.com', 'professor'
        click_on "Edit Profile"

        fill_in 'First Name', with: 'Bill'
        fill_in 'Last Name', with: 'Nye'

        click_on 'Update Profile'

        assert_text "Profile successfully updated!"
        assert_text "Welcome, Bill Nye"
    end

end