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

ActiveRecord::Schema.define(:version => 20131119004552) do

  create_table "blast_results", :force => true do |t|
    t.string   "query"
    t.integer  "len"
    t.string   "result"
    t.integer  "bitscore"
    t.integer  "score"
    t.string   "expect"
    t.string   "identities"
    t.integer  "identities_percent"
    t.string   "gaps"
    t.integer  "gaps_percent"
    t.string   "strand"
    t.string   "accession"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "identifiers", :force => true do |t|
    t.string  "accession"
    t.integer "gi"
    t.integer "taxid"
  end

  add_index "identifiers", ["accession"], :name => "index_identifiers_on_accession", :unique => true
  add_index "identifiers", ["gi"], :name => "index_identifiers_on_gi", :unique => true
  add_index "identifiers", ["taxid"], :name => "index_identifiers_on_taxid"

  create_table "names", :force => true do |t|
    t.integer "taxid"
    t.string  "name_txt"
    t.string  "name_unique"
    t.string  "name_class"
  end

  add_index "names", ["taxid"], :name => "index_names_on_taxid"

  create_table "nodes", :force => true do |t|
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.string  "rank"
    t.integer "children_count", :default => 0
  end

  add_index "nodes", ["parent_id"], :name => "index_nodes_on_parent_id"

end
