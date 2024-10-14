# frozen_string_literal: true

module Users
  class AssignSkills < ActiveInteraction::Base
    object :user, class: User
    string :skills, default: ''

    def execute
      return if skills.blank?

      skill_names = skills.split(',').map(&:strip)

      found_or_created_skills = skill_names.map do |skill_name|
        Skill.find_or_create_by(name: skill_name)
      end

      user.skills = found_or_created_skills
      user.save!
    end
  end
end
