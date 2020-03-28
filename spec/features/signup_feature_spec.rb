def signup
  visit '/signup'
  fill_in 'First Name', with: 'mahmoud'
  fill_in 'Last Name', with: 'khaled'
  fill_in 'SignUpForm_email', with: 'mahmoud.khaled+87@incorta.com'
  fill_in 'Job Title', with: 'stresscloudtest'
  fill_in 'Company', with: 'stresscloudtest'
  
  find('#SignUpForm_industryId').click
  within('ul.ant-select-dropdown-menu') do
    find('li', text: 'Banking').click
  end

  find('#SignUpForm_acceptTerms', visible: false).click
  find('#SignUpForm_acceptPrivacy', visible: false).click

  fill_in 'SignUpForm_password', with: 'password'
  click_button 'CREATE ACCOUNT'
  expect(page).to have_content 'YOUR ACCOUNT HAS BEEN CREATED'
end


describe "the signin process", type: :feature do
  before :each do
    # User.make(email: 'user@example.com', password: 'password')
  end

  it "signs me in" do

    signup
  end
end