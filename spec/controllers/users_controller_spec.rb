# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    let!(:interests) { [create(:interest, name: 'Reading'), create(:interest, name: 'Music')] }
    let!(:skills) { [create(:skill, name: 'Ruby'), create(:skill, name: 'JavaScript')] }

    let(:valid_params) do
      {
        user: attributes_for(:user, interests: interests.map(&:name), skills: skills.map(&:name).join(','))
      }
    end

    let(:invalid_params) do
      {
        user: attributes_for(:user, name: '', email: '', age: 150, gender: 'unknown', skills: '', interests: [])
      }
    end

    def json_response
      JSON.parse(response.body)
    end

    shared_examples 'unprocessable_entity' do
      it 'returns unprocessable entity status' do
        post(:create, params:)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with valid parameters' do
      it 'creates a new user with successful status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'checks the email of the created user' do
        post :create, params: valid_params
        expect(json_response['email']).to eq('john.doe@example.com')
      end
    end

    context 'with invalid parameters' do
      let(:params) { invalid_params }

      it_behaves_like 'unprocessable_entity'

      it 'returns email validation error' do
        post :create, params: invalid_params
        expect(json_response['errors']).to include("Email can't be blank")
      end

      it 'returns age and gender validation errors' do
        post :create, params: invalid_params
        expect(json_response['errors']).to include(
          'Age is not included in the list', 'Gender is not included in the list'
        )
      end
    end

    context 'with duplicate email' do
      before do
        create(:user) # Создание пользователя с помощью фабрики
      end

      let(:params) { valid_params }

      it_behaves_like 'unprocessable_entity'

      it 'returns error message for duplicate email' do
        post :create, params: valid_params
        expect(json_response['errors']).to include('Email has already been taken')
      end
    end

    context 'when age is outside the allowed range' do
      let(:params) { { user: attributes_for(:user, age: 150) } }

      it_behaves_like 'unprocessable_entity'

      it 'returns error message for age out of range' do
        post(:create, params:)
        expect(json_response['errors']).to include('Age is not included in the list')
      end
    end
  end
end
