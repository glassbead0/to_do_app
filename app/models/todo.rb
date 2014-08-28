class Todo < ActiveRecord::Base
  validates :name, presence: true

  belongs_to :list
  belongs_to :user
end
