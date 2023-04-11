require 'rails_helper'

RSpec.describe Api::V1::FirstZombieApocalypsesController, :type => :controller do
  let!(:item_1) { Item.create(name: "Munição", value: 1) }
  let!(:item_2) { Item.create(name: "Medicamentos", value: 2) }
  let!(:item_3) { Item.create(name: "Comida", value: 3) }
  let!(:user_1) { User.create(name: "Alexa") }
  let!(:user_2) { User.create(name: "Noah") }
  let!(:inventory_1) { Inventory.create(user: user_1) }
  let!(:inventory_2) { Inventory.create(user: user_2) }

  context "POST #register_user" do
    it "should success" do
      post :register_user, params: {
        user: {
          name: "Wendy",
          age: 18,
          gender: "Female",
          infection: false,
          last_location: "(19,31)"
        }
      }
      expect(response).to have_http_status :created
    end

    it "should invalid without name" do
      post :register_user, params: {
        user: {
          age: 22
        }
      }
      expect(response).to have_http_status :unprocessable_entity
    end
  end

  context "POST #perform_barter" do

    it "should success" do
      inventory_1.items << item_3
      inventory_2.items << item_2
      inventory_2.items << item_1

      patch :perform_barter, params: {
        first_user: {
          id: user_1.id,
          items: [
            {
              name: "Comida",
              amount: 1
            }
          ]
        },
        second_user: {
          id: user_2.id,
          items: [
            {
              name: "Munição",
              amount: 1
            },
            {
              name: "Medicamentos",
              amount: 1
            }
          ]
        }
      }
      expect(response).to have_http_status :ok
    end
  end

  context "POST #warn_infection" do
    let!(:user_3) { User.create(name: "Vick") }
    let!(:user_4) { User.create(name: "Enrico") }
    let!(:user_infected) { User.create(name: "Frederico", infection: true) }

    it "should success" do
      patch :warn_infection, params: {
        author_id: user_1.id,
        accused_user_id: user_2.id
      }
      expect(response).to have_http_status :ok
    end

    it "should notify when accused user already infected" do
      patch :warn_infection, params: {
        author_id: user_1.id,
        accused_user_id: user_infected.id
      }
      expect(response).to have_http_status :ok
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to eq('This user is already registered as infected in the system.')
    end

    it "should update accused when 3 users notify infection" do
      patch :warn_infection, params: {
        author_id: user_2.id,
        accused_user_id: user_1.id
      }
      patch :warn_infection, params: {
        author_id: user_3.id,
        accused_user_id: user_1.id
      }
      patch :warn_infection, params: {
        author_id: user_4.id,
        accused_user_id: user_1.id
      }

      user_1.reload
      expect(user_1.infection?).to be_truthy
      expect(response).to have_http_status :ok
      json = JSON.parse(response.body).deep_symbolize_keys
      expect(json[:message]).to eq('Record created successfully!')
    end
  end
  
end
