# frozen_string_literal: true

class User < ApplicationRecord
  has_and_belongs_to_many :interests
  has_and_belongs_to_many :skills, class_name: 'Skill'

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :age, inclusion: { in: 1..90 }
  validates :gender, inclusion: { in: %w[male female] }
end
