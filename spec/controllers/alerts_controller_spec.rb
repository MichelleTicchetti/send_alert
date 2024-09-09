require 'rails_helper'

RSpec.describe AlertsController, type: :controller do
  describe 'POST #create' do
    let(:topic) { create(:topic) }
    let!(:user1) { create(:user) }
    let!(:user2) { create(:user) }

    before do
      create(:subscription, user: user1, topic: topic)
      create(:subscription, user: user2, topic: topic)
    end

    let(:invalid_topic_id) { Topic.maximum(:id).to_i + 1 }

    context 'with valid params' do
      let(:valid_params) do
        {
          topic_id: topic.id,
          message: Faker::Lorem.sentence,
          type: ["InformativeAlert", "UrgentAlert"].sample,
          expiration_time: 2.days.from_now
        }
      end

      it 'creates alerts for all subscribed users' do
        expect {
          post :create, params: valid_params
        }.to change { Alert.count }.by(2)
      end

      context 'after creating alerts' do
        before { post :create, params: valid_params }

        it_behaves_like 'successful creation'
      end
    end

    context 'when topic does not exist' do
      before { post :create, params: { topic_id: 999, message: Faker::Lorem.sentence } }

      it_behaves_like 'error response', :not_found
    end

    context 'when missing parameters' do
      before { post :create, params: { topic_id: topic.id } }

      it_behaves_like 'error response', :unprocessable_entity
    end
  end
end
