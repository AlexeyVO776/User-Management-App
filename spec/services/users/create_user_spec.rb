# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::CreateUser, type: :service do
  let(:valid_params) do
    attributes_for(:user, name: 'John', surname: 'Doe', patronymic: 'Paul', email: 'john.doe@example.com')
  end

  it 'creates a valid user' do
    result = described_class.run(params: valid_params)
    expect(result).to be_valid
  end

  it 'creates a user with the correct full name' do
    result = described_class.run(params: valid_params)
    user = result.result
    expect(user.full_name).to eq('Doe John Paul')
  end

  it 'creates a user with the correct email' do
    result = described_class.run(params: valid_params)
    user = result.result
    expect(user.email).to eq('john.doe@example.com')
  end

  it 'does not create a user if required fields are missing' do
    invalid_params = valid_params.except(:email)
    result = described_class.run(params: invalid_params)
    expect(result).not_to be_valid
  end
end
