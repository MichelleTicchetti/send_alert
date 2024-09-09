require 'rails_helper'

RSpec.shared_examples 'it assigns correctly' do
  it "assigns the correct message to the user's alert" do
    alert = Alert.find_by(user: user, topic: topic)
    expect(alert.message).to eq(message)
  end

  it "assigns the correct type to the user's alert" do
    alert = Alert.find_by(user: user, topic: topic)
    expect(alert.type).to eq(type)
  end
end

RSpec.describe AlertSenderService, type: :service do
  let(:topic) { create(:topic) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:message) { Faker::Lorem.sentence }
  let(:type) { ["InformativeAlert", "UrgentAlert"].sample }

  before do
    create(:subscription, user: user1, topic: topic)
    create(:subscription, user: user2, topic: topic)
  end

  context 'sending alerts to all subscribed users' do
    let(:service) { AlertSenderService.new(topic: topic, message: message, type: type, expiration_time: nil) }

    it 'creates 2 alerts in total' do
      expect { service.call }.to change { Alert.count }.by(2)
    end

    context 'when not having a specific user' do
      before { service.call }

      context 'for user1' do
        let(:user) { user1 }
        it_behaves_like 'it assigns correctly'
      end

      context 'for user2' do
        let(:user) { user2 }
        it_behaves_like 'it assigns correctly'
      end
    end
  end

  context 'sending an alert to a specific user' do
    let(:service) { AlertSenderService.new(topic: topic, message: message, type: type, expiration_time: nil, specific_user: user1) }

    it 'creates an alert for the specific user' do
      expect { service.call }.to change { Alert.where(user: user1).count }.by(1)
    end

    it 'does not create an alert for other users' do
      expect { service.call }.not_to change { Alert.where(user: user2).count }
    end

    context 'when having a specific user' do
      before { service.call }

      let(:user) { user1 }
      it_behaves_like 'it assigns correctly'
    end
  end
end
