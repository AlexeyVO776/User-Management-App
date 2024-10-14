# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Validation, type: :service do
  let(:valid_params) { attributes_for(:user) }

  context 'when all params are valid' do
    it 'passes the validation' do
      result = described_class.run(params: valid_params)
      expect(result).to be_valid
    end
  end

  context 'when email is missing' do
    it 'fails validation due to missing email' do
      result = described_class.run(params: valid_params.merge(email: ''))
      expect(result).not_to be_valid
    end

    it 'returns an error message for missing email' do
      result = described_class.run(params: valid_params.merge(email: ''))
      expect(result.errors.full_messages).to include("Email can't be blank")
    end
  end

  context 'when age is out of range' do
    it 'fails validation due to invalid age' do
      result = described_class.run(params: valid_params.merge(age: 150))
      expect(result).not_to be_valid
    end

    it 'returns an error message for invalid age' do
      result = described_class.run(params: valid_params.merge(age: 150))
      expect(result.errors.full_messages).to include('Age is not included in the list')
    end
  end

  context 'when gender is invalid' do
    it 'fails validation due to invalid gender' do
      result = described_class.run(params: valid_params.merge(gender: 'unknown'))
      expect(result).not_to be_valid
    end

    it 'returns an error message for invalid gender' do
      result = described_class.run(params: valid_params.merge(gender: 'unknown'))
      expect(result.errors.full_messages).to include('Gender is not included in the list')
    end
  end

  context 'when email is already taken' do
    before { create(:user, email: valid_params[:email]) }

    it 'fails validation due to duplicate email' do
      result = described_class.run(params: valid_params)
      expect(result).not_to be_valid
    end

    it 'returns an error message for duplicate email' do
      result = described_class.run(params: valid_params)
      expect(result.errors.full_messages).to include('Email has already been taken')
    end
  end
end
