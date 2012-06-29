# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email 'example@example.com'
    password 'password'
    password_confirmation 'password'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
  
  factory :user_other, :class => User do |u|
    email 'example2@example.com'
    password 'password'
    password_confirmation 'password'
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end
  
  
  sequence :email_seq do |n|
    "somebody#{n}@example.com"
  end
  
  factory :multiple_user, :class => User do |f|
    f.email { Factory.next :email_seq }
    f.password 'password'
    f.password_confirmation 'password'
  end
end