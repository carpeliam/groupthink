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

Document.fixture {
  group = Group.make
  {
    :title => Faker::Lorem.sentence[0,100],
    :body => Faker::Lorem.paragraph,
    :group => group,
    :author => group.leader
  }
}

# Safe to plug in to a request spec, doesn't create group or author
Document.fixture(:request_safe) {{
  :title => Faker::Lorem.sentence[0,100],
  :body => Faker::Lorem.paragraph
}}

Artifact.fixture {
  group = Group.make
  {
    :title => Faker::Lorem.sentence[0,100],
    :description => Faker::Lorem.sentence[0,255],
    :group => group,
    :author => group.leader
  }
}

# Safe to plug in to a request spec, doesn't create group or author
Artifact.fixture(:request_safe) {{
  :title => Faker::Lorem.sentence[0,100],
  :description => Faker::Lorem.sentence[0,255]
}}
