# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    validation = Users::Validation.run(params: user_params)
    unless validation.valid?
      return render json: { errors: validation.errors.full_messages }, status: :unprocessable_entity
    end

    outcome = Users::CreateUser.run(params: user_params)
    return render json: { errors: outcome.errors.full_messages }, status: :unprocessable_entity unless outcome.valid?

    user = outcome.result

    Users::AssignInterests.run(user:, interests: user_params[:interests])

    Users::AssignSkills.run(user:, skills: user_params[:skills])

    render json: user.as_json(include: %i[interests skills]), status: :created
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :surname, :patronymic, :email, :age, :nationality, :country, :gender, :skills,
      interests: []
    )
  end
end
