# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  def create
    outcome = Users::Create.run(params: user_params)

    if outcome.valid?
      render json: outcome.result, status: :created
    else
      render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :surname, :patronymic, :email, :age, :nationality, :country, :gender, :skills,
      interests: []
    )
  end
end
