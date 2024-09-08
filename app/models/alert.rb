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
class Alert < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :message, presence: true
  validates :type, presence: true,  inclusion: { in: %w[InformativeAlert UrgentAlert] }

  scope :unread, -> { where(read: false) }
  scope :expired, -> { where("expiration_time IS NOT NULL AND expiration_time <= ?", Time.current) }
  scope :unexpired, -> { where("expiration_time IS NULL OR expiration_time > ?", Time.current) }

  scope :order_by_priority, -> {
    order(
      "CASE WHEN type = 'UrgentAlert' THEN 0 ELSE 1 END ASC",
      "CASE WHEN type = 'UrgentAlert' THEN created_at DESC ELSE created_at ASC END"
    )
  }


  def mark_as_read
    update(read: true)
  rescue StandardError => e
    Rails.logger.error("Error marking alert as read: #{e.message}")
    false
  end
end
