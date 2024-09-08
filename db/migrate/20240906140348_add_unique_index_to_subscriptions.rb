class AddUniqueIndexToSubscriptions < ActiveRecord::Migration[7.2]
  def change
    add_index :subscriptions, [ :user_id, :topic_id ], unique: true
  end
end
