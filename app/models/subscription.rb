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
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :user_id, uniqueness: { scope: :topic_id }
end
