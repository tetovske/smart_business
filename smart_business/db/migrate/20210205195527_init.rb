class Init < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        create_table :roles do |t|
          t.column :name, :string
          t.timestamps
        end
        create_table :users do |t|
          t.column :uid, :string
          t.column :phone, :string
          t.column :login, :string
          t.column :password, :string
          t.column :jwt_token, :string
          t.datetime :registration_date
          t.column :city, :string
          t.datetime :birth_date

          t.string :email,              null: false, default: ""
          t.string :encrypted_password, null: false, default: ""

          ## Recoverable
          t.string   :reset_password_token
          t.datetime :reset_password_sent_at

          ## Rememberable
          t.datetime :remember_created_at
        end
        create_table :user_roles do |t|
          t.references :role, foreign_key: true
          t.references :user, foreign_key: true
          t.timestamps
        end
        create_table :adverts do |t|
          t.string :advert_code
          t.references :user, foreign_key: { to_table: :users }
          t.string :title
          t.string :pic_url
          t.string :description
          t.datetime :time_slot, default: -> { 'CURRENT_TIMESTAMP' }, null: false
          t.timestamps
        end
        create_table :adverts_ref do |t|
          t.references :source_ad, foreign_key: { to_table: :adverts }
          t.references :linked_ad, foreign_key: { to_table: :adverts }
          t.timestamps
        end
        create_table :black_lists do |t|
          t.string :token
          t.timestamps
        end
        create_table :comments do |t|
          t.string :text
          t.references :user, foreign_key: { to_table: :users }
          t.references :advert, foreign_key: { to_table: :adverts }
          t.timestamps
        end
      end
      dir.down do
        drop_table :user_roles
        drop_table :roles
        drop_table :adverts
        drop_table :users
        drop_table :black_lists
        drop_table :comments
        drop_table :adverts_ref
      end
    end
  end
end
