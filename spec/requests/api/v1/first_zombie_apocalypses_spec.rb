require 'swagger_helper'

RSpec.describe 'api/v1/first_zombie_apocalypses', type: :request do

  path '/api/v1/users/register' do

    post('register_user first_zombie_apocalypse') do
      response(200, 'successful') do

        consumes 'application/json'
        parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
            name: { type: :string },
            age: { type: :integer },
            gender: { type: :string },
            last_location: { type: :string },
            infection: { type: :boolean }
          },
          required: %w[name]
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/update_location' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    patch('update_location first_zombie_apocalypse') do
      response(200, 'successful') do
        let(:id) { '123' }

        consumes 'application/json'
        produces 'application/json'
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            last_location: { type: :string },
          }
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}/update_inventory' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    patch('update_inventory first_zombie_apocalypse') do
      response(200, 'successful') do
        let(:id) { '123' }

        consumes 'application/json'
        produces 'application/json'
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            method: { type: :string },
            item_name: { type: :string }
          }
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/perform_barter' do

    patch('perform_barter first_zombie_apocalypse') do
      response(200, 'successful') do

        consumes 'application/json'
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            first_user: {
              type: :object,
              properties: {
                id: { type: :integer },
                items: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    amount: { type: :integer }
                  }
                }
              }
            },
            second_user: {
              type: :object,
              properties: {
                id: { type: :integer },
                items: {
                  type: :object,
                  properties: {
                    name: { type: :string },
                    amount: { type: :integer }
                  }
                }
              }
            }
          }
        }
        

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/warn_infection' do

    patch('warn_infection first_zombie_apocalypse') do
      response(200, 'successful') do

        consumes 'application/json'
        produces 'application/json'
        parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
            author_id: { type: :integer },
            accused_user_id: { type: :integer }
          }
        }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/users/users_data_report' do

    get('users_data_report first_zombie_apocalypse') do
      response(200, 'successful') do

        produces "application/json"

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
