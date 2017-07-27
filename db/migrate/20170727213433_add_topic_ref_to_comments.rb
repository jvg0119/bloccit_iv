class AddTopicRefToComments < ActiveRecord::Migration[5.1]
  def change
    add_reference :comments, :topic, index: true
    add_foreign_key :comments, :topics
  end
end
