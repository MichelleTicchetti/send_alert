require 'rails_helper'

shared_examples 'successful creation' do
  it 'returns success and status created' do
    it 'returns status created' do
      expect(response).to have_http_status(:created)
    end

    it 'returns success true' do
      expect(JSON.parse(response.body)['success']).to be true
    end
  end
end

shared_examples 'error response' do |status|
  it "returns status #{status}" do
    expect(response).to have_http_status(status)
  end

  it 'returns success false' do
    expect(JSON.parse(response.body)['success']).to be false
  end
end

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
          type: [ "InformativeAlert", "UrgentAlert" ].sample,
          expiration_time: 2.days.from_now
        }
      end

      it 'creates alerts for all subscribed users' do
        expect {
          post :create, params: valid_params
        }.to change { Alert.count }.by(2)

        context 'after creating alerts' do
          before { post :create, params: valid_params }
          include_examples 'successful creation'
        end
      end
    end

    context 'when topic does not exist' do
      it 'returns error' do
        post :create, params: { topic_id: 999, message:  Faker::Lorem.sentence }

        include_examples 'error response', :not_found
      end
    end

    context 'when missing parameters' do
      it 'returns error' do
        post :create, params: { topic_id: topic.id }

        include_examples 'error response', :not_found
      end
    end
  end
end
