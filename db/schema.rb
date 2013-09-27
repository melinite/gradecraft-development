# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130927215842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignment_files", force: true do |t|
    t.string  "filename"
    t.integer "assignment_id"
  end

  create_table "assignment_groups", force: true do |t|
    t.integer "group_id"
    t.integer "assignment_id"
  end

  create_table "assignment_rubrics", force: true do |t|
    t.integer  "assignment_id"
    t.integer  "rubric_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assignment_rubrics", ["assignment_id"], name: "index_assignment_rubrics_on_assignment_id", using: :btree
  add_index "assignment_rubrics", ["rubric_id"], name: "index_assignment_rubrics_on_rubric_id", using: :btree

  create_table "assignment_score_levels", force: true do |t|
    t.integer  "assignment_id", null: false
    t.string   "name",          null: false
    t.integer  "value",         null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "assignment_submissions", force: true do |t|
    t.integer  "assignment_id"
    t.integer  "user_id"
    t.string   "feedback"
    t.string   "comment"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "link"
    t.integer  "submittable_id"
    t.string   "submittable_type"
    t.text     "text_feedback"
    t.text     "text_comment"
  end

  create_table "assignment_types", force: true do |t|
    t.string   "name"
    t.string   "point_setting"
    t.boolean  "levels"
    t.string   "points_predictor_display"
    t.integer  "resubmission"
    t.integer  "max_value"
    t.integer  "percentage_course"
    t.text     "predictor_description"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "course_id"
    t.integer  "universal_point_value"
    t.integer  "minimum_score"
    t.integer  "step_value",                        default: 1
    t.integer  "grade_scheme_id"
    t.boolean  "due_date_present"
    t.integer  "order_placement"
    t.boolean  "mass_grade"
    t.string   "mass_grade_type"
    t.boolean  "student_weightable"
    t.string   "student_logged_button_text"
    t.string   "student_logged_revert_button_text"
  end

  create_table "assignment_weights", force: true do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "student_id",                     null: false
    t.integer  "assignment_type_id",             null: false
    t.integer  "weight",                         null: false
    t.integer  "assignment_id",                  null: false
    t.integer  "course_id"
    t.integer  "point_total",        default: 0, null: false
  end

  add_index "assignment_weights", ["assignment_id"], name: "index_assignment_weights_on_assignment_id", using: :btree
  add_index "assignment_weights", ["course_id"], name: "index_assignment_weights_on_course_id", using: :btree
  add_index "assignment_weights", ["student_id", "assignment_id"], name: "index_weights_on_student_id_and_assignment_id", unique: true, using: :btree
  add_index "assignment_weights", ["student_id", "assignment_type_id"], name: "index_assignment_weights_on_student_id_and_assignment_type_id", using: :btree

  create_table "assignments", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "point_total"
    t.datetime "due_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "level"
    t.boolean  "present"
    t.integer  "course_id"
    t.integer  "assignment_type_id"
    t.integer  "grade_scheme_id"
    t.string   "grade_scope",                 default: "Individual", null: false
    t.datetime "close_time"
    t.datetime "open_time"
    t.boolean  "required"
    t.boolean  "accepts_submissions"
    t.boolean  "student_logged"
    t.boolean  "release_necessary",           default: false,        null: false
    t.datetime "open_at"
    t.string   "icon"
    t.boolean  "can_earn_multiple_times"
    t.boolean  "visible",                     default: true
    t.integer  "category_id"
    t.boolean  "resubmissions_allowed"
    t.integer  "max_submissions"
    t.datetime "accepts_submissions_until"
    t.datetime "accepts_resubmissions_until"
    t.datetime "grading_due_at"
    t.string   "role_necessary_for_release"
    t.string   "media"
    t.string   "thumbnail"
    t.string   "media_credit"
    t.string   "media_caption"
    t.string   "points_predictor_display"
  end

  add_index "assignments", ["course_id"], name: "index_assignments_on_course_id", using: :btree

  create_table "badge_files", force: true do |t|
    t.string  "filename"
    t.integer "badge_id"
  end

  create_table "badge_sets", force: true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "badge_sets_courses", id: false, force: true do |t|
    t.integer "course_id"
    t.integer "badge_set_id"
  end

  create_table "badges", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "point_total"
    t.integer  "course_id"
    t.integer  "assignment_id"
    t.integer  "badge_set_id"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "visible"
    t.boolean  "can_earn_multiple_times"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "course_id"
  end

  add_index "categories", ["course_id"], name: "index_categories_on_course_id", using: :btree

  create_table "challenge_files", force: true do |t|
    t.string  "filename"
    t.integer "challenge_id"
  end

  create_table "challenge_grades", force: true do |t|
    t.integer  "challenge_id"
    t.integer  "score"
    t.string   "feedback"
    t.boolean  "status"
    t.integer  "team_id"
    t.integer  "final_score"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "challenges", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "point_total"
    t.datetime "due_at"
    t.integer  "course_id"
    t.string   "points_predictor_display"
    t.boolean  "visible"
    t.boolean  "accepts_submissions"
    t.boolean  "release_necessary"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.datetime "open_at"
    t.boolean  "mass_grade"
    t.string   "mass_grade_type"
    t.boolean  "levels"
    t.string   "media"
    t.string   "thumbnail"
    t.string   "media_credit"
    t.string   "media_caption"
  end

  create_table "course_badge_sets", force: true do |t|
    t.integer "course_id"
    t.integer "badge_set_id"
  end

  create_table "course_categories", id: false, force: true do |t|
    t.integer "course_id"
    t.integer "category_id"
  end

  create_table "course_grade_scheme_elements", force: true do |t|
    t.string   "name"
    t.string   "letter_grade"
    t.integer  "low_range"
    t.integer  "high_range"
    t.integer  "course_grade_scheme_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "course_grade_schemes", force: true do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
  end

  create_table "course_memberships", force: true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.integer  "score",             default: 0, null: false
    t.boolean  "shared_badges"
    t.text     "character_profile"
    t.datetime "last_login_at"
  end

  add_index "course_memberships", ["course_id", "user_id"], name: "index_course_memberships_on_course_id_and_user_id", unique: true, using: :btree
  add_index "course_memberships", ["course_id", "user_id"], name: "index_courses_users_on_course_id_and_user_id", using: :btree
  add_index "course_memberships", ["user_id", "course_id"], name: "index_courses_users_on_user_id_and_course_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "courseno"
    t.string   "year"
    t.string   "semester"
    t.integer  "grade_scheme_id"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.boolean  "badge_setting",                                      default: true
    t.boolean  "team_setting",                                       default: false
    t.string   "user_term"
    t.string   "team_term"
    t.string   "homepage_message"
    t.boolean  "status",                                             default: true
    t.boolean  "group_setting"
    t.integer  "badge_set_id"
    t.datetime "assignment_weight_close_at"
    t.boolean  "team_roles"
    t.string   "team_leader_term"
    t.string   "group_term"
    t.string   "assignment_weight_type"
    t.boolean  "accepts_submissions"
    t.boolean  "teams_visible"
    t.string   "badge_use_scope"
    t.string   "weight_term"
    t.boolean  "predictor_setting"
    t.boolean  "badges_value"
    t.integer  "max_group_size"
    t.integer  "min_group_size"
    t.boolean  "shared_badges"
    t.boolean  "graph_display"
    t.decimal  "default_assignment_weight",  precision: 4, scale: 1, default: 1.0
    t.string   "tagline"
    t.boolean  "academic_history_visible"
    t.string   "office"
    t.string   "phone"
    t.string   "class_email"
    t.string   "twitter_handle"
    t.string   "twitter_hashtag"
    t.string   "location"
    t.string   "office_hours"
    t.text     "meeting_times"
    t.string   "media_file"
    t.string   "media_credit"
    t.string   "media_caption"
    t.string   "badge_term"
    t.string   "assignment_term"
    t.string   "challenge_term"
    t.boolean  "use_timeline"
    t.text     "grading_philosophy"
    t.integer  "total_assignment_weight"
    t.integer  "max_assignment_weight"
    t.boolean  "check_final_grade"
    t.boolean  "character_profiles"
    t.string   "lti_uid"
    t.boolean  "team_score_average"
    t.boolean  "team_challenges"
  end

  add_index "courses", ["lti_uid"], name: "index_courses_on_lti_uid", using: :btree

  create_table "criteria", force: true do |t|
    t.string   "name"
    t.integer  "rubric_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "category"
  end

  create_table "criteria_levels", force: true do |t|
    t.string   "name"
    t.integer  "criteria_id"
    t.text     "description"
    t.integer  "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "criterium_levels", force: true do |t|
    t.string   "name"
    t.integer  "criterium_id"
    t.text     "description"
    t.integer  "value"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "dashboards", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "earned_badges", force: true do |t|
    t.integer  "badge_id"
    t.integer  "submission_id"
    t.integer  "course_id"
    t.integer  "student_id"
    t.integer  "task_id"
    t.integer  "grade_id"
    t.integer  "group_id"
    t.string   "group_type"
    t.integer  "score"
    t.text     "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "shared"
  end

  create_table "elements", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "badge_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "faqs", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.integer  "order"
    t.string   "category"
    t.string   "audience"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grade_criteria", force: true do |t|
    t.integer  "criterium_id"
    t.integer  "rubric_id"
    t.integer  "course_id"
    t.integer  "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "grade_id"
    t.integer  "score",         default: 0, null: false
    t.integer  "student_id"
  end

  add_index "grade_criteria", ["assignment_id"], name: "index_grade_criteria_on_assignment_id", using: :btree
  add_index "grade_criteria", ["course_id"], name: "index_grade_criteria_on_course_id", using: :btree
  add_index "grade_criteria", ["criterium_id"], name: "index_grade_criteria_on_criterium_id", using: :btree
  add_index "grade_criteria", ["grade_id"], name: "index_grade_criteria_on_grade_id", using: :btree
  add_index "grade_criteria", ["rubric_id"], name: "index_grade_criteria_on_rubric_id", using: :btree
  add_index "grade_criteria", ["student_id"], name: "index_grade_criteria_on_student_id", using: :btree

  create_table "grade_files", force: true do |t|
    t.integer "grade_id"
    t.string  "filename"
  end

  create_table "grade_scheme_elements", force: true do |t|
    t.string   "level"
    t.integer  "low_range"
    t.string   "letter"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "grade_scheme_id"
    t.string   "description"
    t.integer  "high_range"
    t.integer  "team_id"
  end

  create_table "grade_schemes", force: true do |t|
    t.integer  "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.string   "name"
    t.text     "description"
  end

  create_table "grades", force: true do |t|
    t.integer  "raw_score",          default: 0
    t.integer  "assignment_id"
    t.text     "feedback"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete"
    t.boolean  "semis"
    t.boolean  "finals"
    t.string   "type"
    t.string   "status"
    t.boolean  "attempted"
    t.boolean  "substantial"
    t.integer  "final_score"
    t.integer  "submission_id"
    t.integer  "course_id"
    t.boolean  "shared"
    t.integer  "student_id"
    t.integer  "task_id"
    t.integer  "group_id"
    t.string   "group_type"
    t.integer  "score"
    t.integer  "assignment_type_id"
    t.integer  "point_total"
    t.text     "admin_notes"
    t.integer  "graded_by_id"
    t.integer  "team_id"
    t.boolean  "released"
  end

  add_index "grades", ["assignment_id"], name: "index_grades_on_assignment_id", using: :btree
  add_index "grades", ["assignment_type_id"], name: "index_grades_on_assignment_type_id", using: :btree
  add_index "grades", ["course_id"], name: "index_grades_on_course_id", using: :btree
  add_index "grades", ["group_id", "group_type"], name: "index_grades_on_group_id_and_group_type", using: :btree
  add_index "grades", ["score"], name: "index_grades_on_score", using: :btree
  add_index "grades", ["task_id"], name: "index_grades_on_task_id", using: :btree

  create_table "group_memberships", force: true do |t|
    t.integer  "group_id"
    t.integer  "student_id"
    t.string   "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
    t.string   "group_type"
  end

  add_index "group_memberships", ["course_id"], name: "index_group_memberships_on_course_id", using: :btree
  add_index "group_memberships", ["group_id", "group_type"], name: "index_group_memberships_on_group_id_and_group_type", using: :btree
  add_index "group_memberships", ["student_id"], name: "index_group_memberships_on_student_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.string   "approved"
    t.string   "proposal"
    t.text     "text_proposal"
  end

  create_table "lti_providers", force: true do |t|
    t.string   "name"
    t.string   "uid"
    t.string   "consumer_key"
    t.string   "consumer_secret"
    t.string   "launch_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rubric_categories", force: true do |t|
    t.integer "rubric_id"
    t.string  "name"
  end

  create_table "rubrics", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "course_id"
    t.integer  "category_id"
  end

  add_index "rubrics", ["category_id"], name: "index_rubrics_on_category_id", using: :btree
  add_index "rubrics", ["course_id"], name: "index_rubrics_on_course_id", using: :btree

  create_table "score_levels", force: true do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "assignment_type_id"
    t.integer  "assignment_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "student_academic_histories", force: true do |t|
    t.integer "student_id"
    t.string  "major"
    t.decimal "gpa"
    t.integer "current_term_credits"
    t.integer "accumulated_credits"
    t.string  "year_in_school"
    t.string  "state_of_residence"
    t.string  "high_school"
    t.boolean "athlete"
    t.integer "act_score"
    t.integer "sat_score"
  end

  create_table "student_assignment_type_weights", force: true do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "student_id"
    t.integer  "assignment_type_id"
    t.integer  "weight",             null: false
  end

  create_table "submission_files", force: true do |t|
    t.string  "filename",      null: false
    t.integer "submission_id", null: false
  end

  create_table "submissions", force: true do |t|
    t.integer  "assignment_id"
    t.integer  "student_id"
    t.string   "feedback"
    t.string   "comment"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.string   "link"
    t.text     "text_feedback"
    t.text     "text_comment"
    t.integer  "creator_id"
    t.integer  "group_id"
    t.boolean  "graded"
    t.datetime "released_at"
    t.integer  "task_id"
    t.integer  "course_id"
    t.integer  "assignment_type_id"
    t.string   "assignment_type"
  end

  add_index "submissions", ["assignment_type"], name: "index_submissions_on_assignment_type", using: :btree
  add_index "submissions", ["course_id"], name: "index_submissions_on_course_id", using: :btree

  create_table "tasks", force: true do |t|
    t.integer  "assignment_id"
    t.string   "name"
    t.text     "description"
    t.datetime "due_at"
    t.boolean  "accepts_submissions"
    t.boolean  "group"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.string   "assignment_type"
    t.string   "type"
    t.string   "taskable_type"
  end

  add_index "tasks", ["assignment_id", "assignment_type"], name: "index_tasks_on_assignment_id_and_assignment_type", using: :btree
  add_index "tasks", ["course_id"], name: "index_tasks_on_course_id", using: :btree
  add_index "tasks", ["id", "type"], name: "index_tasks_on_id_and_type", using: :btree

  create_table "team_memberships", force: true do |t|
    t.integer  "team_id"
    t.integer  "student_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", force: true do |t|
    t.string   "name"
    t.integer  "course_id"
    t.integer  "rank"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "themes", force: true do |t|
    t.string   "name"
    t.string   "filename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: true do |t|
    t.string   "username",                                            null: false
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.string   "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "role",                            default: "student", null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "rank"
    t.string   "display_name"
    t.boolean  "private_display",                 default: false
    t.integer  "default_course_id"
    t.string   "final_grade"
    t.integer  "visit_count"
    t.integer  "predictor_views"
    t.integer  "page_views"
    t.string   "team_role"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string   "lti_uid"
    t.string   "last_login_from_ip_address"
    t.string   "kerberos_uid"
  end

  add_index "users", ["kerberos_uid"], name: "index_users_on_kerberos_uid", using: :btree
  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

end
