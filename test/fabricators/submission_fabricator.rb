Fabricator(:submission) do
  task
  student { Fabricate(:student) }
  feedback "MyString"
  comment "MyString"
end
