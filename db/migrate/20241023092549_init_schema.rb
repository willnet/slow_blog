class InitSchema < ActiveRecord::Migration[8.0]
  def up
   create_table "comments", force: :cascade do |t|
    t.integer "post_id", null: false
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index [ "post_id" ], name: "index_comments_on_post_id"
    t.index [ "user_id" ], name: "index_comments_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "view_count", default: 0, null: false
    t.index [ "status", "user_id" ], name: "index_posts_on_status_and_user_id"
  end

  create_table "posts_tags", id: false, force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "tag_id", null: false
    t.index [ "post_id", "tag_id" ], name: "index_posts_tags_on_post_id_and_tag_id"
    t.index [ "tag_id", "post_id" ], name: "index_posts_tags_on_tag_id_and_post_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "user_id" ], name: "index_sessions_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.integer "post_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "post_id" ], name: "index_taggings_on_post_id"
    t.index [ "tag_id" ], name: "index_taggings_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "name" ], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index [ "email_address" ], name: "index_users_on_email_address", unique: true
    t.index [ "name" ], name: "index_users_on_name", unique: true
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "taggings", "posts"
  add_foreign_key "taggings", "tags"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
