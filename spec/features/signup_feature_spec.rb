def signup(email, company)
  visit '/signup'
  fill_in 'First Name', with: 'mahmoud'
  fill_in 'Last Name', with: 'khaled'
  fill_in 'SignUpForm_email', with: email
  fill_in 'Job Title', with: 'stresscloudtest'
  # fill_in 'Company', with: 'stress-gke'
  fill_in 'Company', with: company


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

def open_cluster(company)
  start = Time.now
  Capybara.using_wait_time(12*60) do # 12 minutes
    expect(page).to have_content 'OPEN'

    # incorta_window = window_opened_by { click_button 'OPEN' }
    # time_to_create = (Time.now - start).to_i
    # puts "*"*20
    # puts "Time taken to start cluster #{(Time.now - start).to_i} seconds"
    # puts "*"*20


    # within_window incorta_window do
    #   expect(page).to have_content 'Unified Data Analytics Platform'
    # end

    # return {window: incorta_window, time: time_to_create}

    visit("http://#{company}.gke-staging.incortalabs.com/incorta")
    time_to_create = (Time.now - start).to_i
    puts "*"*20
    puts "Time taken to start cluster #{(Time.now - start).to_i} seconds"
    puts "*"*20


    expect(page).to have_content 'Unified Data Analytics Platform'

    return {time: time_to_create}
  end
end

def login_incorta
  # fill_in 'tenant', with: 'demo'
  fill_in 'tenant', with: 'default'

  fill_in 'username', with: 'admin'
  fill_in 'password', with: '123456'
  click_button 'Sign In'
  expect(page).to have_content 'Home'
end

def open_dashboard
end

def load_schema(schema_name)
  click_on "Schema"
  find("div[title='#{schema_name}']").click
  within_frame(0) do
    find('a#load_types_btn').click
    find('a', text: 'Load now').hover
    find('a', text: 'Full').click

    loading_start = Time.now
    click_button 'Load'
    expect(page).to have_content 'Loading Data'

    Capybara.using_wait_time(7*60) do
      # loading finished
      expect(page).not_to have_content 'Loading Data'
    end

    return {loading_time: (Time.now - loading_start).to_i}

  end

end

describe "Incorta cloud stress testing", type: :feature do
  before :each do
  end

  it "signs me up" do
    start = Time.now
    email = "mahmoud.khaled+#{rand(4549366632)}@incorta.com"
    # email = "mahmoud.khaled+346416089@incorta.com"

    company = "stress-mo124-#{Time.now.strftime('%H%M%S')}"
    # company = "stress-mo124-180506"
    result = {email: email, company: company}

    
    signup(email, company)

    login(email)

    c = open_cluster(company)
    result.merge!({cluster_creation_time: c[:time]})
    # incorta_window = c[:window]

    # within_window incorta_window do
      login_incorta
      open_dashboard
      result.merge!({trial1: load_schema('OnlineStore')})
      result.merge!({trial2: load_schema('OnlineStore')})
      result.merge!({trial3: load_schema('OnlineStore')})
      # result.merge!({trial4: load_schema('OnlineStore')})
      # result.merge!({trial5: load_schema('OnlineStore')})


    # end

    result[time: (Time.now - start).to_i]
    puts result

    f = File.open('foo.txt', 'a')
    f.write("\n")
    f.write("\n")

    f.write(result)
    f.close
  end
end