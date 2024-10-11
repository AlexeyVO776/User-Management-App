# frozen_string_literal: true

class CreateJoinTableUsersInterests < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :interests do |t|
      t.index %i[user_id interest_id]
    end
  end
end
