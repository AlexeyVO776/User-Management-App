# frozen_string_literal: true

class CreateJoinTableUsersSkills < ActiveRecord::Migration[7.0]
  def change
    create_join_table :users, :skills do |t|
      t.index %i[user_id skill_id]
    end
  end
end
