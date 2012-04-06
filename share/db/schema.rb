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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120406042241) do

  create_table "problems", :force => true do |t|
    t.string   "title"
    t.text     "statement"
    t.float    "time_limit"
    t.float    "memory_limit"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "submissions", :force => true do |t|
    t.string   "author"
    t.integer  "problem"
    t.string   "lang"
    t.string   "verdict"
    t.text     "code"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "test_results", :force => true do |t|
    t.string   "verdict"
    t.text     "output"
    t.float    "cpu"
    t.float    "memory"
    t.integer  "testcase_id"
    t.integer  "submission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "test_results", ["submission_id"], :name => "index_test_results_on_submission_id"

  create_table "testcases", :force => true do |t|
    t.text     "input"
    t.text     "output"
    t.integer  "problem_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "testcases", ["problem_id"], :name => "index_testcases_on_problem_id"

  create_table "testresults", :force => true do |t|
    t.string   "rails"
    t.string   "g"
    t.string   "model"
    t.string   "testresult"
    t.string   "verdict"
    t.text     "output"
    t.float    "cpu"
    t.float    "memory"
    t.integer  "testcase_id"
    t.integer  "submission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "testresults", ["submission_id"], :name => "index_testresults_on_submission_id"

end
