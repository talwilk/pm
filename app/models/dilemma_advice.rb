class DilemmaAdvice < ActiveRecord::Base
  belongs_to :user, -> { with_deleted }
  belongs_to :dilemma, -> { with_deleted }
  has_many :media, as: :mediable, dependent: :destroy
  has_many :user_points_logs, as: :gamificable
  accepts_nested_attributes_for :media, allow_destroy: true

  acts_as_paranoid
  acts_as_votable

  validates :content, presence: true
end
