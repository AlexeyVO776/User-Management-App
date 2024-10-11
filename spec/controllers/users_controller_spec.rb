# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #create' do
    let(:valid_params) do
      {
        user: {
          name: 'John',
          surname: 'Doe',
          patronymic: 'Paul',
          email: 'john.doe@example.com',
          age: 30,
          nationality: 'American',
          country: 'USA',
          gender: 'male',
          interests: %w[Reading Music],
          skills: 'Ruby,JavaScript'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          name: '',
          surname: 'Doe',
          patronymic: 'Paul',
          email: '',
          age: 150,
          nationality: 'American',
          country: 'USA',
          gender: 'unknown',
          interests: [],
          skills: ''
        }
      }
    end

    before do
      Interest.create!(name: 'Reading')
      Interest.create!(name: 'Music')
      Skill.create!(name: 'Ruby')
      Skill.create!(name: 'JavaScript')
    end

    context 'with valid parameters' do
      it 'creates a new user with successful status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end

      it 'checks the email of the created user' do
        post :create, params: valid_params
        expect(JSON.parse(response.body)['email']).to eq('john.doe@example.com')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a user and returns unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns email validation error' do
        post :create, params: invalid_params
        expect(JSON.parse(response.body)['errors']).to include("Email can't be blank")
      end

      it 'returns age and gender validation errors' do
        post :create, params: invalid_params
        expect(JSON.parse(response.body)['errors']).to include(
          'Age is not included in the list',
          'Gender is not included in the list'
        )
      end
    end

    context 'with duplicate email' do
      before do
        User.create!(
          name: 'John',
          surname: 'Doe',
          patronymic: 'Paul',
          email: 'john.doe@example.com',
          age: 30,
          nationality: 'American',
          country: 'USA',
          gender: 'male'
        )
      end

      it 'returns unprocessable entity status for duplicate email' do
        post :create, params: valid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message for duplicate email' do
        post :create, params: valid_params
        expect(JSON.parse(response.body)['errors']).to include('Email has already been taken')
      end
    end

    context 'when age is outside the allowed range' do
      let(:params_with_invalid_age) do
        {
          user: {
            name: 'John',
            surname: 'Doe',
            patronymic: 'Paul',
            email: 'john.doe@nomail.com',
            age: 150,
            nationality: 'American',
            country: 'USA',
            gender: 'male'
          }
        }
      end

      it 'returns unprocessable entity status for invalid age' do
        post :create, params: params_with_invalid_age
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error message for age out of range' do
        post :create, params: params_with_invalid_age
        expect(JSON.parse(response.body)['errors']).to include('Age is not included in the list')
      end
    end
  end
end
