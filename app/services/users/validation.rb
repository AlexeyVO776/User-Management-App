# frozen_string_literal: true

module Users
  class Validation < ActiveInteraction::Base
    hash :params do
      string :email
      integer :age
      string :gender
    end

    validate :validate_email, :validate_age, :validate_gender

    def execute
      errors.empty?
    end

    private

    def validate_email
      errors.add(:email, "can't be blank") if params[:email].blank?
      errors.add(:email, 'has already been taken') if User.exists?(email: params[:email])
    end

    def validate_age
      errors.add(:age, 'is not included in the list') unless (1..90).include?(params[:age])
    end

    def validate_gender
      errors.add(:gender, 'is not included in the list') unless %w[male female].include?(params[:gender])
    end
  end
end
