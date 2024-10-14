# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::AssignInterests, type: :service do
  let(:user) { create(:user) }

  context 'when interests are provided' do
    let(:interests) { create_list(:interest, 2, name: 'Reading') }

    it 'assigns the provided interests to the user' do
      result = described_class.run(user:, interests: interests.map(&:name))
      expect(result).to be_valid
    end

    it 'assigns the correct interests to the user' do
      described_class.run(user:, interests: interests.map(&:name))
      expect(user.interests.pluck(:name)).to match_array(interests.map(&:name))
    end
  end

  context 'when interests are empty' do
    it 'does not assign any interests' do
      result = described_class.run(user:, interests: [])
      expect(result).to be_valid
    end

    it 'does not update user interests if none are provided' do
      described_class.run(user:, interests: [])
      expect(user.interests).to be_empty
    end
  end
end
