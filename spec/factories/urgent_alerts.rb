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
FactoryBot.define do
  factory :urgent_alert, class: 'UrgentAlert' do
    message { Faker::Lorem.sentence }
    expiration_time { Faker::Time.forward(days: 10, period: :morning) }
    read { false }
    user
    topic
  end
end
