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

ActiveRecord::Schema.define(version: 20170320051650) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.integer  "container_id"
    t.string   "container_type", limit: 30
    t.string   "filename",                  default: "", null: false
    t.string   "disk_filename",             default: "", null: false
    t.integer  "filesize",       limit: 8,  default: 0,  null: false
    t.string   "content_type",              default: ""
    t.string   "digest",         limit: 64, default: "", null: false
    t.integer  "downloads",                 default: 0,  null: false
    t.integer  "author_id",                 default: 0,  null: false
    t.datetime "created_on"
    t.string   "description"
    t.string   "disk_directory"
  end

  add_index "attachments", ["author_id"], name: "index_attachments_on_author_id", using: :btree
  add_index "attachments", ["container_id", "container_type"], name: "index_attachments_on_container_id_and_container_type", using: :btree
  add_index "attachments", ["created_on"], name: "index_attachments_on_created_on", using: :btree
  add_index "attachments", ["disk_filename"], name: "index_attachments_on_disk_filename", using: :btree

  create_table "auth_sources", force: :cascade do |t|
    t.string  "type",              limit: 30,  default: "",    null: false
    t.string  "name",              limit: 60,  default: "",    null: false
    t.string  "host",              limit: 60
    t.integer "port"
    t.string  "account"
    t.string  "account_password",              default: ""
    t.string  "base_dn",           limit: 255
    t.string  "attr_login",        limit: 30
    t.string  "attr_firstname",    limit: 30
    t.string  "attr_lastname",     limit: 30
    t.string  "attr_mail",         limit: 30
    t.boolean "onthefly_register",             default: false, null: false
    t.boolean "tls",                           default: false, null: false
    t.text    "filter"
    t.integer "timeout"
  end

  add_index "auth_sources", ["id", "type"], name: "index_auth_sources_on_id_and_type", using: :btree

  create_table "boards", force: :cascade do |t|
    t.integer "project_id",                   null: false
    t.string  "name",            default: "", null: false
    t.string  "description"
    t.integer "position"
    t.integer "topics_count",    default: 0,  null: false
    t.integer "messages_count",  default: 0,  null: false
    t.integer "last_message_id"
    t.integer "parent_id"
  end

  add_index "boards", ["last_message_id"], name: "index_boards_on_last_message_id", using: :btree
  add_index "boards", ["project_id"], name: "boards_project_id", using: :btree

  create_table "changes", force: :cascade do |t|
    t.integer "changeset_id",                         null: false
    t.string  "action",        limit: 1, default: "", null: false
    t.text    "path",                                 null: false
    t.text    "from_path"
    t.string  "from_revision"
    t.string  "revision"
    t.string  "branch"
  end

  add_index "changes", ["changeset_id"], name: "changesets_changeset_id", using: :btree

  create_table "changeset_parents", id: false, force: :cascade do |t|
    t.integer "changeset_id", null: false
    t.integer "parent_id",    null: false
  end

  add_index "changeset_parents", ["changeset_id"], name: "changeset_parents_changeset_ids", using: :btree
  add_index "changeset_parents", ["parent_id"], name: "changeset_parents_parent_ids", using: :btree

  create_table "changesets", force: :cascade do |t|
    t.integer  "repository_id", null: false
    t.string   "revision",      null: false
    t.string   "committer"
    t.datetime "committed_on",  null: false
    t.text     "comments"
    t.date     "commit_date"
    t.string   "scmid"
    t.integer  "user_id"
  end

  add_index "changesets", ["committed_on"], name: "index_changesets_on_committed_on", using: :btree
  add_index "changesets", ["repository_id", "revision"], name: "changesets_repos_rev", unique: true, using: :btree
  add_index "changesets", ["repository_id", "scmid"], name: "changesets_repos_scmid", using: :btree
  add_index "changesets", ["repository_id"], name: "index_changesets_on_repository_id", using: :btree
  add_index "changesets", ["user_id"], name: "index_changesets_on_user_id", using: :btree

  create_table "changesets_issues", id: false, force: :cascade do |t|
    t.integer "changeset_id", null: false
    t.integer "issue_id",     null: false
  end

  add_index "changesets_issues", ["changeset_id", "issue_id"], name: "changesets_issues_ids", unique: true, using: :btree
  add_index "changesets_issues", ["issue_id"], name: "index_changesets_issues_on_issue_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "commented_type", limit: 30, default: "", null: false
    t.integer  "commented_id",              default: 0,  null: false
    t.integer  "author_id",                 default: 0,  null: false
    t.text     "comments"
    t.datetime "created_on",                             null: false
    t.datetime "updated_on",                             null: false
  end

  add_index "comments", ["author_id"], name: "index_comments_on_author_id", using: :btree
  add_index "comments", ["commented_id", "commented_type"], name: "index_comments_on_commented_id_and_commented_type", using: :btree

  create_table "custom_field_enumerations", force: :cascade do |t|
    t.integer "custom_field_id",                null: false
    t.string  "name",                           null: false
    t.boolean "active",          default: true, null: false
    t.integer "position",        default: 1,    null: false
  end

  create_table "custom_fields", force: :cascade do |t|
    t.string  "type",            limit: 30, default: "",    null: false
    t.string  "name",            limit: 30, default: "",    null: false
    t.string  "field_format",    limit: 30, default: "",    null: false
    t.text    "possible_values"
    t.string  "regexp",                     default: ""
    t.integer "min_length"
    t.integer "max_length"
    t.boolean "is_required",                default: false, null: false
    t.boolean "is_for_all",                 default: false, null: false
    t.boolean "is_filter",                  default: false, null: false
    t.integer "position"
    t.boolean "searchable",                 default: false
    t.text    "default_value"
    t.boolean "editable",                   default: true
    t.boolean "visible",                    default: true,  null: false
    t.boolean "multiple",                   default: false
    t.text    "format_store"
    t.text    "description"
  end

  add_index "custom_fields", ["id", "type"], name: "index_custom_fields_on_id_and_type", using: :btree

  create_table "custom_fields_projects", id: false, force: :cascade do |t|
    t.integer "custom_field_id", default: 0, null: false
    t.integer "project_id",      default: 0, null: false
  end

  add_index "custom_fields_projects", ["custom_field_id", "project_id"], name: "index_custom_fields_projects_on_custom_field_id_and_project_id", unique: true, using: :btree

  create_table "custom_fields_roles", id: false, force: :cascade do |t|
    t.integer "custom_field_id", null: false
    t.integer "role_id",         null: false
  end

  add_index "custom_fields_roles", ["custom_field_id", "role_id"], name: "custom_fields_roles_ids", unique: true, using: :btree

  create_table "custom_fields_trackers", id: false, force: :cascade do |t|
    t.integer "custom_field_id", default: 0, null: false
    t.integer "tracker_id",      default: 0, null: false
  end

  add_index "custom_fields_trackers", ["custom_field_id", "tracker_id"], name: "index_custom_fields_trackers_on_custom_field_id_and_tracker_id", unique: true, using: :btree

  create_table "custom_values", force: :cascade do |t|
    t.string  "customized_type", limit: 30, default: "", null: false
    t.integer "customized_id",              default: 0,  null: false
    t.integer "custom_field_id",            default: 0,  null: false
    t.text    "value"
  end

  add_index "custom_values", ["custom_field_id"], name: "index_custom_values_on_custom_field_id", using: :btree
  add_index "custom_values", ["customized_type", "customized_id"], name: "custom_values_customized", using: :btree

  create_table "documents", force: :cascade do |t|
    t.integer  "project_id",  default: 0,  null: false
    t.integer  "category_id", default: 0,  null: false
    t.string   "title",       default: "", null: false
    t.text     "description"
    t.datetime "created_on"
  end

  add_index "documents", ["category_id"], name: "index_documents_on_category_id", using: :btree
  add_index "documents", ["created_on"], name: "index_documents_on_created_on", using: :btree
  add_index "documents", ["project_id"], name: "documents_project_id", using: :btree

  create_table "email_addresses", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.string   "address",                    null: false
    t.boolean  "is_default", default: false, null: false
    t.boolean  "notify",     default: true,  null: false
    t.datetime "created_on",                 null: false
    t.datetime "updated_on",                 null: false
  end

  add_index "email_addresses", ["user_id"], name: "index_email_addresses_on_user_id", using: :btree

  create_table "enabled_modules", force: :cascade do |t|
    t.integer "project_id"
    t.string  "name",       null: false
  end

  add_index "enabled_modules", ["project_id"], name: "enabled_modules_project_id", using: :btree

  create_table "enumerations", force: :cascade do |t|
    t.string  "name",          limit: 30, default: "",    null: false
    t.integer "position"
    t.boolean "is_default",               default: false, null: false
    t.string  "type"
    t.boolean "active",                   default: true,  null: false
    t.integer "project_id"
    t.integer "parent_id"
    t.string  "position_name", limit: 30
  end

  add_index "enumerations", ["id", "type"], name: "index_enumerations_on_id_and_type", using: :btree
  add_index "enumerations", ["project_id"], name: "index_enumerations_on_project_id", using: :btree

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "groups_users_ids", unique: true, using: :btree

  create_table "import_items", force: :cascade do |t|
    t.integer "import_id", null: false
    t.integer "position",  null: false
    t.integer "obj_id"
    t.text    "message"
  end

  create_table "imports", force: :cascade do |t|
    t.string   "type"
    t.integer  "user_id",                     null: false
    t.string   "filename"
    t.text     "settings"
    t.integer  "total_items"
    t.boolean  "finished",    default: false, null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "issue_categories", force: :cascade do |t|
    t.integer "project_id",                default: 0,  null: false
    t.string  "name",           limit: 60, default: "", null: false
    t.integer "assigned_to_id"
  end

  add_index "issue_categories", ["assigned_to_id"], name: "index_issue_categories_on_assigned_to_id", using: :btree
  add_index "issue_categories", ["project_id"], name: "issue_categories_project_id", using: :btree

  create_table "issue_relations", force: :cascade do |t|
    t.integer "issue_from_id",              null: false
    t.integer "issue_to_id",                null: false
    t.string  "relation_type", default: "", null: false
    t.integer "delay"
  end

  add_index "issue_relations", ["issue_from_id", "issue_to_id"], name: "index_issue_relations_on_issue_from_id_and_issue_to_id", unique: true, using: :btree
  add_index "issue_relations", ["issue_from_id"], name: "index_issue_relations_on_issue_from_id", using: :btree
  add_index "issue_relations", ["issue_to_id"], name: "index_issue_relations_on_issue_to_id", using: :btree

  create_table "issue_statuses", force: :cascade do |t|
    t.string  "name",               limit: 30, default: "",    null: false
    t.boolean "is_closed",                     default: false, null: false
    t.integer "position"
    t.integer "default_done_ratio"
  end

  add_index "issue_statuses", ["is_closed"], name: "index_issue_statuses_on_is_closed", using: :btree
  add_index "issue_statuses", ["position"], name: "index_issue_statuses_on_position", using: :btree

  create_table "issues", force: :cascade do |t|
    t.integer  "tracker_id",                       null: false
    t.integer  "project_id",                       null: false
    t.string   "subject",          default: "",    null: false
    t.text     "description"
    t.date     "due_date"
    t.integer  "category_id"
    t.integer  "status_id",                        null: false
    t.integer  "assigned_to_id"
    t.integer  "priority_id",                      null: false
    t.integer  "fixed_version_id"
    t.integer  "author_id",                        null: false
    t.integer  "lock_version",     default: 0,     null: false
    t.datetime "created_on"
    t.datetime "updated_on"
    t.date     "start_date"
    t.integer  "done_ratio",       default: 0,     null: false
    t.float    "estimated_hours"
    t.integer  "parent_id"
    t.integer  "root_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.boolean  "is_private",       default: false, null: false
    t.datetime "closed_on"
  end

  add_index "issues", ["assigned_to_id"], name: "index_issues_on_assigned_to_id", using: :btree
  add_index "issues", ["author_id"], name: "index_issues_on_author_id", using: :btree
  add_index "issues", ["category_id"], name: "index_issues_on_category_id", using: :btree
  add_index "issues", ["created_on"], name: "index_issues_on_created_on", using: :btree
  add_index "issues", ["fixed_version_id"], name: "index_issues_on_fixed_version_id", using: :btree
  add_index "issues", ["parent_id"], name: "index_issues_on_parent_id", using: :btree
  add_index "issues", ["priority_id"], name: "index_issues_on_priority_id", using: :btree
  add_index "issues", ["project_id"], name: "issues_project_id", using: :btree
  add_index "issues", ["root_id", "lft", "rgt"], name: "index_issues_on_root_id_and_lft_and_rgt", using: :btree
  add_index "issues", ["status_id"], name: "index_issues_on_status_id", using: :btree
  add_index "issues", ["tracker_id"], name: "index_issues_on_tracker_id", using: :btree

  create_table "journal_details", force: :cascade do |t|
    t.integer "journal_id",            default: 0,  null: false
    t.string  "property",   limit: 30, default: "", null: false
    t.string  "prop_key",   limit: 30, default: "", null: false
    t.text    "old_value"
    t.text    "value"
  end

  add_index "journal_details", ["journal_id"], name: "journal_details_journal_id", using: :btree

  create_table "journals", force: :cascade do |t|
    t.integer  "journalized_id",              default: 0,     null: false
    t.string   "journalized_type", limit: 30, default: "",    null: false
    t.integer  "user_id",                     default: 0,     null: false
    t.text     "notes"
    t.datetime "created_on",                                  null: false
    t.boolean  "private_notes",               default: false, null: false
  end

  add_index "journals", ["created_on"], name: "index_journals_on_created_on", using: :btree
  add_index "journals", ["journalized_id", "journalized_type"], name: "journals_journalized_id", using: :btree
  add_index "journals", ["journalized_id"], name: "index_journals_on_journalized_id", using: :btree
  add_index "journals", ["user_id"], name: "index_journals_on_user_id", using: :btree

  create_table "member_roles", force: :cascade do |t|
    t.integer "member_id",      null: false
    t.integer "role_id",        null: false
    t.integer "inherited_from"
  end

  add_index "member_roles", ["inherited_from"], name: "index_member_roles_on_inherited_from", using: :btree
  add_index "member_roles", ["member_id"], name: "index_member_roles_on_member_id", using: :btree
  add_index "member_roles", ["role_id"], name: "index_member_roles_on_role_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "user_id",           default: 0,     null: false
    t.integer  "project_id",        default: 0,     null: false
    t.datetime "created_on"
    t.boolean  "mail_notification", default: false, null: false
  end

  add_index "members", ["project_id"], name: "index_members_on_project_id", using: :btree
  add_index "members", ["user_id", "project_id"], name: "index_members_on_user_id_and_project_id", unique: true, using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "board_id",                      null: false
    t.integer  "parent_id"
    t.string   "subject",       default: "",    null: false
    t.text     "content"
    t.integer  "author_id"
    t.integer  "replies_count", default: 0,     null: false
    t.integer  "last_reply_id"
    t.datetime "created_on",                    null: false
    t.datetime "updated_on",                    null: false
    t.boolean  "locked",        default: false
    t.integer  "sticky",        default: 0
  end

  add_index "messages", ["author_id"], name: "index_messages_on_author_id", using: :btree
  add_index "messages", ["board_id"], name: "messages_board_id", using: :btree
  add_index "messages", ["created_on"], name: "index_messages_on_created_on", using: :btree
  add_index "messages", ["last_reply_id"], name: "index_messages_on_last_reply_id", using: :btree
  add_index "messages", ["parent_id"], name: "messages_parent_id", using: :btree

  create_table "news", force: :cascade do |t|
    t.integer  "project_id"
    t.string   "title",          limit: 60,  default: "", null: false
    t.string   "summary",        limit: 255, default: ""
    t.text     "description"
    t.integer  "author_id",                  default: 0,  null: false
    t.datetime "created_on"
    t.integer  "comments_count",             default: 0,  null: false
  end

  add_index "news", ["author_id"], name: "index_news_on_author_id", using: :btree
  add_index "news", ["created_on"], name: "index_news_on_created_on", using: :btree
  add_index "news", ["project_id"], name: "news_project_id", using: :btree

  create_table "open_id_authentication_associations", force: :cascade do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", force: :cascade do |t|
    t.integer "timestamp",  null: false
    t.string  "server_url"
    t.string  "salt",       null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",                   default: "",    null: false
    t.text     "description"
    t.string   "homepage",               default: ""
    t.boolean  "is_public",              default: true,  null: false
    t.integer  "parent_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "identifier"
    t.integer  "status",                 default: 1,     null: false
    t.integer  "lft"
    t.integer  "rgt"
    t.boolean  "inherit_members",        default: false, null: false
    t.integer  "default_version_id"
    t.integer  "default_assigned_to_id"
  end

  add_index "projects", ["lft"], name: "index_projects_on_lft", using: :btree
  add_index "projects", ["rgt"], name: "index_projects_on_rgt", using: :btree

  create_table "projects_trackers", id: false, force: :cascade do |t|
    t.integer "project_id", default: 0, null: false
    t.integer "tracker_id", default: 0, null: false
  end

  add_index "projects_trackers", ["project_id", "tracker_id"], name: "projects_trackers_unique", unique: true, using: :btree
  add_index "projects_trackers", ["project_id"], name: "projects_trackers_project_id", using: :btree

  create_table "queries", force: :cascade do |t|
    t.integer "project_id"
    t.string  "name",          default: "", null: false
    t.text    "filters"
    t.integer "user_id",       default: 0,  null: false
    t.text    "column_names"
    t.text    "sort_criteria"
    t.string  "group_by"
    t.string  "type"
    t.integer "visibility",    default: 0
    t.text    "options"
  end

  add_index "queries", ["project_id"], name: "index_queries_on_project_id", using: :btree
  add_index "queries", ["user_id"], name: "index_queries_on_user_id", using: :btree

  create_table "queries_roles", id: false, force: :cascade do |t|
    t.integer "query_id", null: false
    t.integer "role_id",  null: false
  end

  add_index "queries_roles", ["query_id", "role_id"], name: "queries_roles_ids", unique: true, using: :btree

  create_table "repositories", force: :cascade do |t|
    t.integer  "project_id",                default: 0,     null: false
    t.string   "url",                       default: "",    null: false
    t.string   "login",         limit: 60,  default: ""
    t.string   "password",                  default: ""
    t.string   "root_url",      limit: 255, default: ""
    t.string   "type"
    t.string   "path_encoding", limit: 64
    t.string   "log_encoding",  limit: 64
    t.text     "extra_info"
    t.string   "identifier"
    t.boolean  "is_default",                default: false
    t.datetime "created_on"
  end

  add_index "repositories", ["project_id"], name: "index_repositories_on_project_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string  "name",                    limit: 30, default: "",        null: false
    t.integer "position"
    t.boolean "assignable",                         default: true
    t.integer "builtin",                            default: 0,         null: false
    t.text    "permissions"
    t.string  "issues_visibility",       limit: 30, default: "default", null: false
    t.string  "users_visibility",        limit: 30, default: "all",     null: false
    t.string  "time_entries_visibility", limit: 30, default: "all",     null: false
    t.boolean "all_roles_managed",                  default: true,      null: false
    t.text    "settings"
  end

  create_table "roles_managed_roles", id: false, force: :cascade do |t|
    t.integer "role_id",         null: false
    t.integer "managed_role_id", null: false
  end

  add_index "roles_managed_roles", ["role_id", "managed_role_id"], name: "index_roles_managed_roles_on_role_id_and_managed_role_id", unique: true, using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.text     "value"
    t.datetime "updated_on"
  end

  add_index "settings", ["name"], name: "index_settings_on_name", using: :btree

  create_table "time_entries", force: :cascade do |t|
    t.integer  "project_id",               null: false
    t.integer  "user_id",                  null: false
    t.integer  "issue_id"
    t.float    "hours",                    null: false
    t.string   "comments",    limit: 1024
    t.integer  "activity_id",              null: false
    t.date     "spent_on",                 null: false
    t.integer  "tyear",                    null: false
    t.integer  "tmonth",                   null: false
    t.integer  "tweek",                    null: false
    t.datetime "created_on",               null: false
    t.datetime "updated_on",               null: false
  end

  add_index "time_entries", ["activity_id"], name: "index_time_entries_on_activity_id", using: :btree
  add_index "time_entries", ["created_on"], name: "index_time_entries_on_created_on", using: :btree
  add_index "time_entries", ["issue_id"], name: "time_entries_issue_id", using: :btree
  add_index "time_entries", ["project_id"], name: "time_entries_project_id", using: :btree
  add_index "time_entries", ["user_id"], name: "index_time_entries_on_user_id", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.integer  "user_id",               default: 0,  null: false
    t.string   "action",     limit: 30, default: "", null: false
    t.string   "value",      limit: 40, default: "", null: false
    t.datetime "created_on",                         null: false
    t.datetime "updated_on"
  end

  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree
  add_index "tokens", ["value"], name: "tokens_value", unique: true, using: :btree

  create_table "trackers", force: :cascade do |t|
    t.string  "name",              limit: 30, default: "",    null: false
    t.boolean "is_in_chlog",                  default: false, null: false
    t.integer "position"
    t.boolean "is_in_roadmap",                default: true,  null: false
    t.integer "fields_bits",                  default: 0
    t.integer "default_status_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.integer "user_id",   default: 0,    null: false
    t.text    "others"
    t.boolean "hide_mail", default: true
    t.string  "time_zone"
  end

  add_index "user_preferences", ["user_id"], name: "index_user_preferences_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",                          default: "",    null: false
    t.string   "hashed_password",    limit: 40,  default: "",    null: false
    t.string   "firstname",          limit: 30,  default: "",    null: false
    t.string   "lastname",           limit: 255, default: "",    null: false
    t.boolean  "admin",                          default: false, null: false
    t.integer  "status",                         default: 1,     null: false
    t.datetime "last_login_on"
    t.string   "language",           limit: 5,   default: ""
    t.integer  "auth_source_id"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "type"
    t.string   "identity_url"
    t.string   "mail_notification",              default: "",    null: false
    t.string   "salt",               limit: 64
    t.boolean  "must_change_passwd",             default: false, null: false
    t.datetime "passwd_changed_on"
  end

  add_index "users", ["auth_source_id"], name: "index_users_on_auth_source_id", using: :btree
  add_index "users", ["id", "type"], name: "index_users_on_id_and_type", using: :btree
  add_index "users", ["type"], name: "index_users_on_type", using: :btree

  create_table "versions", force: :cascade do |t|
    t.integer  "project_id",      default: 0,      null: false
    t.string   "name",            default: "",     null: false
    t.string   "description",     default: ""
    t.date     "effective_date"
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "wiki_page_title"
    t.string   "status",          default: "open"
    t.string   "sharing",         default: "none", null: false
  end

  add_index "versions", ["project_id"], name: "versions_project_id", using: :btree
  add_index "versions", ["sharing"], name: "index_versions_on_sharing", using: :btree

  create_table "watchers", force: :cascade do |t|
    t.string  "watchable_type", default: "", null: false
    t.integer "watchable_id",   default: 0,  null: false
    t.integer "user_id"
  end

  add_index "watchers", ["user_id", "watchable_type"], name: "watchers_user_id_type", using: :btree
  add_index "watchers", ["user_id"], name: "index_watchers_on_user_id", using: :btree
  add_index "watchers", ["watchable_id", "watchable_type"], name: "index_watchers_on_watchable_id_and_watchable_type", using: :btree

  create_table "wiki_content_versions", force: :cascade do |t|
    t.integer  "wiki_content_id",                           null: false
    t.integer  "page_id",                                   null: false
    t.integer  "author_id"
    t.binary   "data"
    t.string   "compression",     limit: 6,    default: ""
    t.string   "comments",        limit: 1024, default: ""
    t.datetime "updated_on",                                null: false
    t.integer  "version",                                   null: false
  end

  add_index "wiki_content_versions", ["updated_on"], name: "index_wiki_content_versions_on_updated_on", using: :btree
  add_index "wiki_content_versions", ["wiki_content_id"], name: "wiki_content_versions_wcid", using: :btree

  create_table "wiki_contents", force: :cascade do |t|
    t.integer  "page_id",                              null: false
    t.integer  "author_id"
    t.text     "text"
    t.string   "comments",   limit: 1024, default: ""
    t.datetime "updated_on",                           null: false
    t.integer  "version",                              null: false
  end

  add_index "wiki_contents", ["author_id"], name: "index_wiki_contents_on_author_id", using: :btree
  add_index "wiki_contents", ["page_id"], name: "wiki_contents_page_id", using: :btree

  create_table "wiki_pages", force: :cascade do |t|
    t.integer  "wiki_id",                                null: false
    t.string   "title",      limit: 255,                 null: false
    t.datetime "created_on",                             null: false
    t.boolean  "protected",              default: false, null: false
    t.integer  "parent_id"
  end

  add_index "wiki_pages", ["parent_id"], name: "index_wiki_pages_on_parent_id", using: :btree
  add_index "wiki_pages", ["wiki_id", "title"], name: "wiki_pages_wiki_id_title", using: :btree
  add_index "wiki_pages", ["wiki_id"], name: "index_wiki_pages_on_wiki_id", using: :btree

  create_table "wiki_redirects", force: :cascade do |t|
    t.integer  "wiki_id",              null: false
    t.string   "title"
    t.string   "redirects_to"
    t.datetime "created_on",           null: false
    t.integer  "redirects_to_wiki_id", null: false
  end

  add_index "wiki_redirects", ["wiki_id", "title"], name: "wiki_redirects_wiki_id_title", using: :btree
  add_index "wiki_redirects", ["wiki_id"], name: "index_wiki_redirects_on_wiki_id", using: :btree

  create_table "wikis", force: :cascade do |t|
    t.integer "project_id",                         null: false
    t.string  "start_page", limit: 255,             null: false
    t.integer "status",                 default: 1, null: false
  end

  add_index "wikis", ["project_id"], name: "wikis_project_id", using: :btree

  create_table "workflows", force: :cascade do |t|
    t.integer "tracker_id",               default: 0,     null: false
    t.integer "old_status_id",            default: 0,     null: false
    t.integer "new_status_id",            default: 0,     null: false
    t.integer "role_id",                  default: 0,     null: false
    t.boolean "assignee",                 default: false, null: false
    t.boolean "author",                   default: false, null: false
    t.string  "type",          limit: 30
    t.string  "field_name",    limit: 30
    t.string  "rule",          limit: 30
  end

  add_index "workflows", ["new_status_id"], name: "index_workflows_on_new_status_id", using: :btree
  add_index "workflows", ["old_status_id"], name: "index_workflows_on_old_status_id", using: :btree
  add_index "workflows", ["role_id", "tracker_id", "old_status_id"], name: "wkfs_role_tracker_old_status", using: :btree
  add_index "workflows", ["role_id"], name: "index_workflows_on_role_id", using: :btree
  add_index "workflows", ["tracker_id"], name: "index_workflows_on_tracker_id", using: :btree

end
