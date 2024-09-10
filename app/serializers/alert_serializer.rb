class AlertSerializer < ActiveModel::Serializer
  attributes :id, :message, :expiration_time, :read, :specific_user, :type, :user_id, :topic_id, :created_at, :updated_at
end