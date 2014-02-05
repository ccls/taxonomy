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

ActiveRecord::Schema.define(:version => 20140204172702) do

  create_table "blast_results", :force => true do |t|
    t.string  "file_name"
    t.string  "contig_name"
    t.string  "contig_description"
    t.integer "contig_length"
    t.string  "seq_name"
    t.integer "seq_length"
    t.float   "bitscore"
    t.integer "score"
    t.float   "expect"
    t.string  "identities"
    t.integer "identities_percent"
    t.string  "gaps"
    t.integer "gaps_percent"
    t.string  "strand"
    t.string  "accession_prefix"
    t.string  "accession"
  end

  add_index "blast_results", ["accession"], :name => "index_blast_results_on_accession"
  add_index "blast_results", ["file_name"], :name => "index_blast_results_on_file_name"

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

  add_index "names", ["name_class"], :name => "index_names_on_name_class"
  add_index "names", ["taxid", "name_class"], :name => "index_names_on_taxid_and_name_class"
  add_index "names", ["taxid"], :name => "index_names_on_taxid"

  create_table "nodes", :force => true do |t|
    t.integer "taxid"
    t.integer "parent_taxid"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.integer "children_count",  :default => 0
    t.string  "rank"
    t.string  "scientific_name"
  end

  add_index "nodes", ["lft", "rgt"], :name => "index_nodes_on_lft_and_rgt", :unique => true
  add_index "nodes", ["lft"], :name => "index_nodes_on_lft", :unique => true
  add_index "nodes", ["parent_taxid"], :name => "index_nodes_on_parent_taxid"
  add_index "nodes", ["rgt"], :name => "index_nodes_on_rgt", :unique => true
  add_index "nodes", ["taxid"], :name => "index_nodes_on_taxid", :unique => true

end
