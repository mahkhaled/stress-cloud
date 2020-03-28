describe "the signin process", type: :feature do
  before :each do
    # User.make(email: 'user@example.com', password: 'password')
  end

  it "signs me in" do
    visit '/signup'
    within("#session") do
      fill_in 'First Name', with: 'mahmoud'
      fill_in 'Password', with: 'password'
    end
    click_button 'Create Account'
    expect(page).to have_content 'Success'
  end
end