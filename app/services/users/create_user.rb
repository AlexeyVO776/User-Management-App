# frozen_string_literal: true

module Users
  class CreateUser < ActiveInteraction::Base
    hash :params do
      string :name
      string :surname
      string :patronymic
      string :email
      integer :age
      string :nationality
      string :country
      string :gender
    end

    def execute
      user_full_name = "#{params[:surname]} #{params[:name]} #{params[:patronymic]}"
      User.create(params.except(:interests, :skills).merge(full_name: user_full_name))
    end
  end
end
