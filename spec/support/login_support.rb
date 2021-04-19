module LoginSupport
  # ログイン処理
  def log_in_user_for_systemspec(email:, password:)
    visit root_path
    click_link 'Log in'
    fill_in 'session_email',	with: email
    fill_in 'session_password', with: password
    click_button 'Log in'
  end

  def log_in_for_systemspec_as(user)
    visit root_path
    click_link 'Log in'
    fill_in 'session_email',	with: user.email
    fill_in 'session_password', with: user.password
    click_button 'Log in'
  end
end

RSpec.configure do |config|
  config.include(LoginSupport, type: :system)
end
