# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:topics).through(:subscriptions) }
  it { should have_many(:alerts).dependent(:destroy) }

  it { should validate_presence_of(:name) }

  describe '#subscribe_to' do
    let(:user) { create(:user) }
    let(:topic) { create(:topic) }

    it 'allows user to subscribe to a topic' do
      user.subscribe_to(topic)

      expect(user.topics).to include(topic)
    end

    it 'not allows user to have duplicated suscription to topic' do
      user.subscribe_to(topic)
      user.subscribe_to(topic)

      expect(user.subscriptions.count).to eq(1)
    end
  end
end
