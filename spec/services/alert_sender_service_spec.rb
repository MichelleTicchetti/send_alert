require 'rails_helper'

shared_examples 'it assigns correctly' do |user, topic, message, type|
  it "message to #{user.name}'s alert" do
    alert = Alert.find_by(user: user, topic: topic)
    expect(alert.message).to eq(message)
  end

  it "type to #{user.name}'s alert" do
    alert = Alert.find_by(user: user, topic: topic)
    expect(alert.type).to eq(type)
  end
end

RSpec.describe AlertSenderService, type: :service do
  let(:topic) { create(:topic) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:message) { Faker::Lorem.sentence }
  let(:type) { [ "InformativeAlert", "UrgentAlert" ].sample }
  let(:service) { AlertSenderService.new(topic, message, type, nil) }

  before do
    create(:subscription, user: user1, topic: topic)
    create(:subscription, user: user2, topic: topic)
  end

  it 'sends alerts to all subscribed users' do
    expect { service.call }.to change { Alert.count }.by(2)
  end

  context 'after sending alerts' do
    before { service.call }

    include_examples 'it assigns correctly', user1, topic, message, type
    include_examples 'it assigns correctly', user2, topic, message, type
  end
end
