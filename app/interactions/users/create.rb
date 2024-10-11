# frozen_string_literal: true

module Users
  class Create < ActiveInteraction::Base
    hash :params do
      string :name
      string :surname
      string :patronymic
      string :email
      integer :age
      string :nationality
      string :country
      string :gender
      array :interests, default: []
      string :skills, default: ''
    end

    validate :validate_presence_of_email, :validate_age, :validate_gender, :check_existing_user

    def execute
      user = create_user
      return errors.merge!(user.errors) unless user.persisted?

      assign_interests(user)
      assign_skills(user)
      user
    end

    private

    def validate_presence_of_email
      errors.add(:email, "can't be blank") if params[:email].blank?
    end

    def validate_age
      return if (1..90).include?(params[:age])

      errors.add(:age, 'is not included in the list')
    end

    def validate_gender
      return if %w[male female].include?(params[:gender])

      errors.add(:gender, 'is not included in the list')
    end

    def check_existing_user
      return unless User.exists?(email: params[:email])

      errors.add(:email, 'has already been taken')
    end

    def create_user
      user_full_name = "#{params[:surname]} #{params[:name]} #{params[:patronymic]}"
      User.create(params.except(:interests, :skills).merge(full_name: user_full_name))
    end

    def assign_interests(user)
      interests = Interest.where(name: params[:interests])
      user.interests << interests if interests.present?
    end

    def assign_skills(user)
      skill_names = params[:skills].split(',').map(&:strip) if params[:skills].present?
      skills = Skill.where(name: skill_names)
      user.skills << skills if skills.present?
    end
  end
end
