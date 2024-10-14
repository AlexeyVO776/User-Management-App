# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'John' }
    surname { 'Doe' }
    patronymic { 'Paul' }
    email { 'john.doe@example.com' }
    age { 30 }
    nationality { 'American' }
    country { 'USA' }
    gender { 'male' }
  end
end
