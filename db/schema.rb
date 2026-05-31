# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_31_072657) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "areas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "vidhansabha_id", null: false
    t.index ["vidhansabha_id", "name"], name: "index_areas_on_vidhansabha_id_and_name", unique: true
    t.index ["vidhansabha_id"], name: "index_areas_on_vidhansabha_id"
  end

  create_table "campaign_supports", force: :cascade do |t|
    t.string "area"
    t.integer "campaign_id", null: false
    t.datetime "created_at", null: false
    t.text "message"
    t.string "name"
    t.string "phone_number"
    t.datetime "updated_at", null: false
    t.string "village_or_ward"
    t.index ["campaign_id"], name: "index_campaign_supports_on_campaign_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.integer "campaign_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "image_url"
    t.string "language"
    t.datetime "scheduled_at"
    t.string "target_area"
    t.integer "target_support_status", default: 3, null: false
    t.string "target_village"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "mobile_otp_verifications", force: :cascade do |t|
    t.integer "attempts_count"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.string "ip_address"
    t.datetime "last_sent_at"
    t.string "otp_digest"
    t.string "phone_number"
    t.string "purpose"
    t.integer "resend_count"
    t.datetime "updated_at", null: false
    t.datetime "verified_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "from_user_id"
    t.text "message", null: false
    t.string "notification_type"
    t.integer "public_request_id"
    t.boolean "read", default: false, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["created_at"], name: "index_notifications_on_created_at"
    t.index ["public_request_id"], name: "index_notifications_on_public_request_id"
    t.index ["user_id", "read"], name: "index_notifications_on_user_id_and_read"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_permissions_on_key", unique: true
  end

  create_table "population_records", force: :cascade do |t|
    t.string "aadhaar_document_url"
    t.string "aadhaar_image_url"
    t.text "address"
    t.integer "age"
    t.string "area"
    t.integer "area_ref_id"
    t.string "assigned_worker"
    t.string "booth_number"
    t.datetime "created_at", null: false
    t.integer "family_count", default: 1, null: false
    t.string "full_name"
    t.integer "gender", default: 0, null: false
    t.string "name"
    t.text "notes"
    t.string "phone_number"
    t.text "political_engagement"
    t.integer "political_support_status", default: 3, null: false
    t.integer "rural_or_urban", default: 0, null: false
    t.text "tags"
    t.datetime "updated_at", null: false
    t.integer "vidhansabha_id"
    t.string "village"
    t.string "village_or_ward"
    t.integer "village_ward_id"
    t.string "voter_id"
    t.string "ward"
    t.boolean "whatsapp_consent", default: false, null: false
    t.index ["area"], name: "index_population_records_on_area"
    t.index ["area_ref_id"], name: "index_population_records_on_area_ref_id"
    t.index ["gender"], name: "index_population_records_on_gender"
    t.index ["phone_number"], name: "index_population_records_on_phone_number"
    t.index ["rural_or_urban"], name: "index_population_records_on_rural_or_urban"
    t.index ["vidhansabha_id"], name: "index_population_records_on_vidhansabha_id"
    t.index ["village_or_ward"], name: "index_population_records_on_village_or_ward"
    t.index ["village_ward_id"], name: "index_population_records_on_village_ward_id"
  end

  create_table "pr_posts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", null: false
    t.string "image_url"
    t.string "language"
    t.datetime "published_at"
    t.datetime "scheduled_at"
    t.integer "status", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_pr_posts_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.text "biography"
    t.string "constituency"
    t.text "contact_info"
    t.datetime "created_at", null: false
    t.string "department"
    t.text "focus_areas"
    t.string "image_url"
    t.string "name"
    t.string "party"
    t.text "political_experience"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "public_requests", force: :cascade do |t|
    t.string "area"
    t.datetime "assigned_at"
    t.integer "assigned_by_id"
    t.string "assigned_to"
    t.integer "assigned_to_user_id"
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "document_url"
    t.boolean "escalated", default: false, null: false
    t.date "expected_resolution_date"
    t.string "image_url"
    t.text "internal_notes"
    t.string "name"
    t.string "phone_number"
    t.text "public_response"
    t.integer "public_user_id"
    t.string "request_title"
    t.text "resolution_summary"
    t.integer "severity", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "village_or_ward"
    t.index ["area"], name: "index_public_requests_on_area"
    t.index ["assigned_by_id"], name: "index_public_requests_on_assigned_by_id"
    t.index ["assigned_to_user_id"], name: "index_public_requests_on_assigned_to_user_id"
    t.index ["category"], name: "index_public_requests_on_category"
    t.index ["created_at"], name: "index_public_requests_on_created_at"
    t.index ["escalated"], name: "index_public_requests_on_escalated"
    t.index ["phone_number"], name: "index_public_requests_on_phone_number"
    t.index ["public_user_id"], name: "index_public_requests_on_public_user_id"
    t.index ["severity"], name: "index_public_requests_on_severity"
    t.index ["status"], name: "index_public_requests_on_status"
    t.index ["village_or_ward"], name: "index_public_requests_on_village_or_ward"
  end

  create_table "request_activities", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.string "new_value"
    t.text "notes"
    t.string "old_value"
    t.integer "public_request_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["public_request_id"], name: "index_request_activities_on_public_request_id"
    t.index ["user_id"], name: "index_request_activities_on_user_id"
  end

  create_table "request_comments", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.boolean "internal", default: true, null: false
    t.integer "public_request_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["public_request_id"], name: "index_request_comments_on_public_request_id"
    t.index ["user_id"], name: "index_request_comments_on_user_id"
  end

  create_table "request_histories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "from_status"
    t.text "note"
    t.integer "public_request_id", null: false
    t.string "to_status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["public_request_id"], name: "index_request_histories_on_public_request_id"
    t.index ["user_id"], name: "index_request_histories_on_user_id"
  end

  create_table "role_permissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "permission_id", null: false
    t.integer "role"
    t.datetime "updated_at", null: false
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role", "permission_id"], name: "index_role_permissions_on_role_and_permission_id", unique: true
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.binary "channel", limit: 1024, null: false
    t.bigint "channel_hash", null: false
    t.datetime "created_at", null: false
    t.binary "payload", limit: 536870912, null: false
    t.index ["channel", "created_at"], name: "index_solid_cable_messages_on_channel_and_created_at", order: { created_at: :desc }
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
  end

  create_table "users", force: :cascade do |t|
    t.text "address"
    t.string "area"
    t.datetime "created_at", null: false
    t.string "mobile_number"
    t.string "name"
    t.string "otp_code"
    t.datetime "otp_requested_at"
    t.string "password_digest"
    t.string "phone_number"
    t.string "preferred_language", default: "hi", null: false
    t.integer "role", default: 3, null: false
    t.integer "rural_or_urban", default: 0, null: false
    t.datetime "updated_at", null: false
    t.string "village_or_ward"
    t.index ["mobile_number"], name: "index_users_on_mobile_number", unique: true
  end

  create_table "vidhansabhas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "district"
    t.string "name"
    t.string "state"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_vidhansabhas_on_name", unique: true
  end

  create_table "village_wards", force: :cascade do |t|
    t.integer "area_id", null: false
    t.datetime "created_at", null: false
    t.integer "kind", default: 0, null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["area_id", "name"], name: "index_village_wards_on_area_id_and_name", unique: true
    t.index ["area_id"], name: "index_village_wards_on_area_id"
  end

  create_table "work_dones", force: :cascade do |t|
    t.string "area"
    t.string "assigned_to"
    t.decimal "budget", precision: 12, scale: 2
    t.string "category"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "population_record_id", null: false
    t.string "proof_image_url"
    t.string "proof_images_url"
    t.text "remarks"
    t.integer "status", default: 0, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "village"
    t.string "work_type"
    t.index ["population_record_id"], name: "index_work_dones_on_population_record_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "areas", "vidhansabhas"
  add_foreign_key "campaign_supports", "campaigns"
  add_foreign_key "notifications", "public_requests"
  add_foreign_key "notifications", "users"
  add_foreign_key "notifications", "users", column: "from_user_id"
  add_foreign_key "population_records", "areas", column: "area_ref_id"
  add_foreign_key "population_records", "vidhansabhas"
  add_foreign_key "population_records", "village_wards"
  add_foreign_key "pr_posts", "users"
  add_foreign_key "public_requests", "users", column: "assigned_by_id"
  add_foreign_key "public_requests", "users", column: "assigned_to_user_id"
  add_foreign_key "public_requests", "users", column: "public_user_id"
  add_foreign_key "request_activities", "public_requests"
  add_foreign_key "request_activities", "users"
  add_foreign_key "request_comments", "public_requests"
  add_foreign_key "request_comments", "users"
  add_foreign_key "request_histories", "public_requests"
  add_foreign_key "request_histories", "users"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "village_wards", "areas"
  add_foreign_key "work_dones", "population_records"
end
