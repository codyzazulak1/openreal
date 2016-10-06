class RemoveFavoritesWishlistsAgentsAppointmentsFeaturesServicesCustomers < ActiveRecord::Migration

  def up

    drop_table :favorites
    drop_table :wishlists
    drop_table :agents
    drop_table :customers

  end

  def down

    create_table :agents do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.timestamps null: false

      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :agent_id
    end

      add_index :agents, :email,                unique: true
      add_index :agents, :reset_password_token, unique: true

    create_table :customers do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      t.string :first_name
      t.string :last_name
      t.string :phone
      t.text :address

      t.timestamps null: false
    end

    add_index :customers, :email,                unique: true
    add_index :customers, :reset_password_token, unique: true

    create_table :favorites do |t|

      t.timestamps null: false

    end

    add_reference :favorites, :customer, index: true, foreign_key: true
    add_reference :favorites, :property, index: true, foreign_key: true

    create_table :wishlists do |t|
      t.string :name
      t.timestamps null: false
    end

    add_reference :wishlists, :customer, foreign_key: true
    add_reference :favorites, :wishlist, foreign_key: true
  end
end
