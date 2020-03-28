def signup(email)
  visit '/signup'
  fill_in 'First Name', with: 'mahmoud'
  fill_in 'Last Name', with: 'khaled'
  fill_in 'SignUpForm_email', with: email
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

def login(email)
  visit '/signin'
  fill_in 'SignInForm_email', with: email
  fill_in 'SignInForm_password', with: 'password'
  click_button 'SIGN IN'

  expect(page).to have_content 'Clusters List'
end

def open_cluster
  start = Time.now
  Capybara.using_wait_time(12*60) do # 12 minutes
    click_button 'OPEN'
  end
  puts "Time taken to start cluster #{(Time.now - start).to_i} seconds"

  expect(page).to have_content 'Unified Data Analytics Platform'

  fill_in 'tenant', with: 'default'
  fill_in 'username', with: 'admin'
  fill_in 'password', with: '1234'
  click_button 'Sign In'
  expect(page).to have_content 'Content'
end

def open_dashboard
end

describe "Incorta cloud stress testing", type: :feature do
  before :each do
  end

  it "signs me up" do
    email = "mahmoud.khaled+#{rand(4549366632)}@incorta.com"
    
    signup(email)

    login(email)

    open_cluster

    open_dashboard
  end
end