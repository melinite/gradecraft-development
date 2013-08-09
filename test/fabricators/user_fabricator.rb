Fabricator(:user) do
  first_name 'Test'
  last_name 'User'
  username { sequence(:username) { |i| "testuser#{i}" } }
  email { sequence(:email) { |i| "user#{i}@gradecraft.local" } }
end

Fabricator(:professor, from: :user) do
  role 'professor'
end

Fabricator(:student, :from => :user) do
  role 'student'
end
