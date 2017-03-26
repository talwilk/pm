class AddLocaleToUserProfiles < ActiveRecord::Migration
  def change
  	add_column :user_profiles, :locale, :string, null: false, default: :he
  	add_index "user_profiles", ["locale"], name: "index_user_profiles_on_locale", using: :btree
  end
end
