require 'dm-sweatshop'
require 'faker'

User.fixture {{
  :login => Faker::Internet.user_name[0,50],
  :password => 'password',
  :password_confirmation => 'password'
}}

Group.fixture {
  leader = User.make
  {
    :name => Faker::Company.name[0,100],
    :leader => leader,
    :users => [leader]
  }
}

# Safe to plug in to a request spec, doesn't create users or leader
Group.fixture(:request_safe) {{
  :name => Faker::Company.name[0,100]
}}

Category.fixture {{
  :name => Faker::Lorem.words.join(' '),
  :group => Group.make
}}

Category.fixture(:request_safe) {{
  :name => Faker::Lorem.words.join(' ')
}}

Document.fixture {
  category = Category.make
  {
    :title => Faker::Lorem.sentence[0,100],
    :body => Faker::Lorem.paragraph,
    :category => category,
    :author => category.group.leader
  }
}

# Safe to plug in to a request spec, doesn't create group or author
Document.fixture(:request_safe) {{
  :title => Faker::Lorem.sentence[0,100],
  :body => Faker::Lorem.paragraph
}}
