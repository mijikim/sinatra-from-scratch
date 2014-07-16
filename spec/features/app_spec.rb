require "spec_helper"

feature "Homepage and Registration" do
  scenario "check homepage" do
    visit "/"
    expect(page).to have_link("Registration")
    expect(page).to have_content("email")
    expect(page).to have_content("password")
    expect(page).to have_button("Login")
  end
  scenario "check registration page" do
    visit "/"
    click_link "Registration"
    expect(page).to have_content("email")
    expect(page).to have_content("password")
  end
end

feature "Register restrictions" do
  scenario "empty email" do
    visit "/"
    fill_in 'email', with: ''
    fill_in 'password', with: 'Ilovekittens'
    click_button "Submit"
    expect(page).to have_content("Please fill in email")
  end
  scenario "empty password" do
    visit "/"
    fill_in 'email', with: 'Lindsay'
    fill_in 'password', with: ''
    click_button "Submit"
    expect(page).to have_content("Please fill in password")
  end
  scenario "empty all" do
    visit "/"
    fill_in 'email', with: ''
    fill_in 'password', with: ''
    click_button "Submit"
    expect(page).to have_content("Please fill in email and password")
  end
  scenario "duplicate emails" do
    create_alex
    create_alex
    expect(page).to have_content("email is already in use, please choose another.")
  end

end
feature "Fill in form and see greeting" do
  scenario "visit registration page" do
    create_alex
    expect(page).to have_content("Thank you for registering")
  end
end
feature "Login and out" do
  scenario "have logged out" do
    create_alex
    alex_login
    expect(page).to have_content("Welcome, Alex")
    expect(page).to have_button("Logout")
    expect(page).to have_no_button("Login")
    expect(page).to have_no_link("Registration")

    click_button "Logout"
    expect(page).to have_no_button("Logout")
    expect(page).to have_button("Login")
    expect(page).to have_link("Registration")
  end
end
feature "Display users" do
  scenario "on user page display other current users" do
    create_users
    alex_login
    expect(page).to have_content("John")
    expect(page).to have_content("Steve")
  end
  scenario "sort" do
    create_users
    alex_login
    expect(page).to have_content("Phil\nJohn\nSteve")
    choose('asc')
    click_button "Sort"
    expect(page).to have_content("John \n Phil \n Steve")
  end

end