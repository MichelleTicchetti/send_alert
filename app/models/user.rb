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
class User < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  has_many :topics, through: :subscriptions
  has_many :alerts, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true

  def subscribe_to!(topic)
    subscriptions.find_or_create_by(topic: topic)
  end

  def unsubscribe_from!(topic)
    subscriptions.find_by(topic: topic)&.destroy
  end

  def mark_all_alerts_as_read!
    unread_alerts = alerts.where(read: false)
    unread_alerts.each do | alert | alert.mark_as_read end
  end

  def mark_alert_as_read!(alert_id)
    alerts.where(id: alert_id).first.mark_as_read
  end
end
