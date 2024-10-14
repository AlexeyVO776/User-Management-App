# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AssignSkills, type: :service do
  let(:user) { create(:user) }

  context 'when skills are provided' do
    let(:skills) { create_list(:skill, 2, name: 'Ruby') }

    it 'assigns the provided skills to the user' do
      result = described_class.run(user:, skills: skills.map(&:name).join(','))
      expect(result).to be_valid
    end

    it 'assigns the correct skills to the user' do
      described_class.run(user:, skills: skills.map(&:name).join(','))
      expect(user.skills.pluck(:name)).to match_array(skills.map(&:name))
    end
  end

  context 'when skills are empty' do
    it 'does not assign any skills' do
      result = described_class.run(user:, skills: '')
      expect(result).to be_valid
    end

    it 'does not update user skills if none are provided' do
      described_class.run(user:, skills: '')
      expect(user.skills).to be_empty
    end
  end
end
