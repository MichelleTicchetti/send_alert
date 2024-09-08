# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_subscriptions_on_topic_id              (topic_id)
#  index_subscriptions_on_user_id               (user_id)
#  index_subscriptions_on_user_id_and_topic_id  (user_id,topic_id) UNIQUE
#
# Foreign Keys
#
#  topic_id  (topic_id => topics.id)
#  user_id   (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:topic) }

  it 'validates unique suscription' do
    user = create(:user)
    topic = create(:topic)

    create(:subscription, user: user, topic: topic)
    duplicate_subscription = build(:subscription, user: user, topic: topic)

    expect(duplicate_subscription).not_to be_valid
  end
end
