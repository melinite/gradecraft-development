require 'test_helper'

class GradeTest < ActionDispatch::IntegrationTest

#   test "test grade index as professor" do
#     create_professor(email: 'dumble@hogwarts.edu', password: 'password')

#     log_in 'dumble@hogwarts.edu', 'password' do
#       create_assignment
#       create_grade
#       visit assignment_path(assignment)
#       page.text.must_include "TEST ASSIGNMENT"
#       page.text.must_include "99"
#     end
#   end

# #new

#   test "test grade show as professor" do
#     create_professor(email: 'dumble@hogwarts.edu', password: 'password')

#     log_in 'dumble@hogwarts.edu', 'password' do
#       visit assignment_grade_path(assignment, grade)
#       page.text.must_include "Test Assignment"
#       page.text.must_include "99"
#     end
#   end

#   test "test self log grade as student" do
#     create_student(email: 'ron.weasley@hogwarts.edu', password: 'password')

#     create_assignment_type(name: 'Attendance', student_logged_button_text: 'Present', student_logged_revert_button_text: 'Absent') do
#       create_assignment(:point_total => 5000, student_logged: true, open_at: 1.day.ago, due_at: 1.day.from_now, release_necessary: false)
#     end

#     log_in 'ron.weasley@hogwarts.edu', 'password' do
#       click_link 'Assignments'

#       within('#tab2') do
#         page.must_have_content 'Attendance 0/5,000'
#         find('button[data-target="#assignment_type-1"]').click
#         click_button('Present')
#         page.must_have_content 'Attendance 5,000/5,000'
#       end
#     end
#   end

#edit

#delete

#mass grade

end
