# Sign in user to 
def sign_in_user(user)
  visit "/users/sign_in"

  fill_in "user_email",                 :with => user.email
  fill_in "Password",              :with => user.password
  
  click_button "Sign in"
end