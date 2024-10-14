# frozen_string_literal: true

module Users
  class AssignInterests < ActiveInteraction::Base
    object :user, class: User
    array :interests, default: []

    def execute
      return if interests.blank?

      found_or_created_interests = interests.map do |interest_name|
        Interest.find_or_create_by(name: interest_name)
      end

      user.interests = found_or_created_interests
      user.save!
    end
  end
end
