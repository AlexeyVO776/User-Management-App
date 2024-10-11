# frozen_string_literal: true

Interest.destroy_all
Skill.destroy_all

interests = %w[Reading Music Traveling Sports Cooking Photography]
interests.each do |interest|
  Interest.create!(name: interest)
end

Rails.logger.debug "#{Interest.count} interests created."

skills = ['Ruby', 'JavaScript', 'Python', 'Java', 'C++', 'SQL']
skills.each do |skill|
  Skill.create!(name: skill)
end

Rails.logger.debug "#{Skill.count} skills created."
