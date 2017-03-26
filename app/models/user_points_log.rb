class UserPointsLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :gamificable, polymorphic: true
end
