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

ActiveRecord::Schema.define(version: 20130729182134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignment_types", force: true do |t|
    t.string   "name"
    t.string   "point_setting"
    t.boolean  "levels"
    t.string   "points_predictor_display"
    t.integer  "resubmission"
    t.integer  "max_value"
    t.integer  "percentage_course"
    t.string   "predictor_description"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "course_id"
    t.integer  "universal_point_value"
    t.integer  "minimum_score"
    t.integer  "step_value",               default: 1
    t.integer  "grade_scheme_id"
    t.boolean  "due_date_present"
    t.integer  "order_placement"
    t.boolean  "mass_grade"
    t.string   "mass_grade_type"
    t.boolean  "student_weightable"
  end

  create_table "assignment_weights", force: true do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "student_id",         null: false
    t.integer  "assignment_type_id", null: false
    t.integer  "weight",             null: false
    t.integer  "assignment_id",      null: false
    t.integer  "course_id"
  end

  add_index "assignment_weights", ["assignment_id"], name: "index_assignment_weights_on_assignment_id", using: :btree
  add_index "assignment_weights", ["course_id"], name: "index_assignment_weights_on_course_id", using: :btree
  add_index "assignment_weights", ["student_id", "assignment_id"], name: "index_weights_on_student_id_and_assignment_id", unique: true, using: :btree

  create_table "assignments", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "point_total"
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "level"
    t.boolean  "present"
    t.integer  "course_id"
    t.integer  "assignment_type_id"
    t.integer  "grade_scheme_id"
    t.string   "grade_scope"
    t.datetime "close_time"
    t.datetime "open_time"
    t.boolean  "required"
    t.boolean  "submissions_allowed"
    t.boolean  "student_logged"
    t.string   "student_logged_button_text"
    t.boolean  "release_necessary"
    t.datetime "open_date"
    t.string   "type"
    t.integer  "parent_id"
    t.string   "icon"
    t.boolean  "can_earn_multiple_times"
    t.boolean  "visible",                    default: true
    t.integer  "category_id"
    t.boolean  "resubmissions_allowed"
    t.integer  "max_submissions"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "course_id"
    t.string   "type"
  end

  add_index "categories", ["course_id"], name: "index_categories_on_course_id", using: :btree

  create_table "course_categories", id: false, force: true do |t|
    t.integer "course_id"
    t.integer "category_id"
  end

  create_table "course_memberships", force: true do |t|
    t.integer "course_id"
    t.integer "user_id"
    t.integer "sortable_score"
    t.string  "shared_badges"
  end

  add_index "course_memberships", ["course_id", "user_id"], name: "index_courses_users_on_course_id_and_user_id", using: :btree
  add_index "course_memberships", ["user_id", "course_id"], name: "index_courses_users_on_user_id_and_course_id", using: :btree

  create_table "courses", force: true do |t|
    t.string   "name"
    t.string   "courseno"
    t.string   "year"
    t.string   "semester"
    t.integer  "grade_scheme_id"
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
    t.boolean  "badge_setting",                                        default: true
    t.boolean  "team_setting",                                         default: false
    t.string   "user_term"
    t.string   "team_term"
    t.string   "homepage_message"
    t.boolean  "status",                                               default: true
    t.boolean  "group_setting"
    t.integer  "badge_set_id"
    t.integer  "total_assignment_weight",                                              null: false
    t.integer  "max_assignment_weight",                                                null: false
    t.datetime "assignment_weight_close_date"
    t.boolean  "team_roles"
    t.string   "section_leader_term"
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
    t.decimal  "default_assignment_weight",    precision: 4, scale: 1, default: 1.0
  end

  create_table "criteria", force: true do |t|
    t.string   "name"
    t.integer  "rubric_id"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "criteria_levels", force: true do |t|
    t.string   "name"
    t.integer  "criteria_id"
    t.text     "description"
    t.integer  "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "dashboards", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grade_scheme_elements", force: true do |t|
    t.string   "name"
    t.integer  "low_range"
    t.string   "letter_grade"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "grade_scheme_id"
    t.string   "description"
    t.integer  "high_range"
  end

  create_table "grade_schemes", force: true do |t|
    t.integer  "assignment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.string   "name"
  end

  create_table "grades", force: true do |t|
    t.integer  "raw_score"
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
    t.integer  "parent_id"
  end

  add_index "grades", ["assignment_id"], name: "index_grades_on_assignment_id", using: :btree
  add_index "grades", ["course_id"], name: "index_grades_on_course_id", using: :btree
  add_index "grades", ["task_id"], name: "index_grades_on_task_id", using: :btree

  create_table "group_memberships", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "course_id"
    t.string   "group_type"
  end

  add_index "group_memberships", ["course_id"], name: "index_group_memberships_on_course_id", using: :btree
  add_index "group_memberships", ["group_id", "group_type"], name: "index_group_memberships_on_group_id_and_group_type", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assignment_id"
    t.integer  "course_id"
    t.string   "approved"
    t.string   "proposal"
    t.text     "text_proposal"
    t.string   "type"
  end

  create_table "rubrics", force: true do |t|
    t.string   "name"
    t.integer  "assignment_id"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "course_id"
  end

  add_index "rubrics", ["course_id"], name: "index_rubrics_on_course_id", using: :btree

  create_table "score_levels", force: true do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "assignment_type_id"
    t.integer  "assignment_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
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
    t.string   "assignment_type"
  end

  add_index "submissions", ["assignment_id", "assignment_type"], name: "index_submissions_on_assignment_id_and_assignment_type", using: :btree
  add_index "submissions", ["course_id"], name: "index_submissions_on_course_id", using: :btree

  create_table "tasks", force: true do |t|
    t.integer  "assignment_id"
    t.string   "title"
    t.text     "description"
    t.datetime "due_at"
    t.boolean  "accepts_submissions"
    t.boolean  "group"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.string   "assignment_type"
    t.string   "type"
  end

  add_index "tasks", ["assignment_id", "assignment_type"], name: "index_tasks_on_assignment_id_and_assignment_type", using: :btree
  add_index "tasks", ["course_id"], name: "index_tasks_on_course_id", using: :btree
  add_index "tasks", ["id", "type"], name: "index_tasks_on_id_and_type", using: :btree

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
  end

  add_index "users", ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree

end
