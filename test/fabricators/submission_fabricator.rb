Fabricator(:submission) do
  assignment
  student
  text_feedback "MyString"
  text_comment "MyString"
end
