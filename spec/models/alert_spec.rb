# == Schema Information
#
# Table name: alerts
#
#  id              :integer          not null, primary key
#  expiration_time :datetime
#  message         :string           not null
#  read            :boolean          default(FALSE)
#  specific_user   :boolean          default(FALSE)
#  type            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  topic_id        :integer          not null
#  user_id         :integer          not null
#
# Indexes
#
#  index_alerts_on_topic_id  (topic_id)
#  index_alerts_on_user_id   (user_id)
#
# Foreign Keys
#
#  topic_id  (topic_id => topics.id)
#  user_id   (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Alert, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:topic) }

  it { should validate_presence_of(:message) }
  it { should validate_presence_of(:type) }

  describe 'Scopes' do
    let!(:unread_alert) { create(:alert, read: false) }
    let!(:read_alert) { create(:alert, read: true) }

    context 'for unread alerts' do
      it 'includes unread alerts' do
        expect(Alert.unread).to include(unread_alert)
      end

      it 'does not include read alerts' do
        expect(Alert.unread).not_to include(read_alert)
      end
    end

    context 'for unexpired alerts' do
      let!(:unexpired_alert) { create(:alert, expiration_time: 1.day.from_now) }
      let!(:expired_alert) { create(:alert, expiration_time: 1.day.ago) }

      it 'includes unexpired alerts' do
        expect(Alert.unexpired).to include(unexpired_alert)
      end

      it 'does not include expired alerts' do
        expect(Alert.unexpired).not_to include(expired_alert)
      end
    end
  end
end
