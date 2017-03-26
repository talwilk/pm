class GuruApplication < ActiveRecord::Base
  belongs_to :user, -> { with_deleted }
  belongs_to :resulter, -> { with_deleted }, class_name: 'SuperAdmin'
  belongs_to :reviewer, -> { with_deleted }, class_name: 'SuperAdmin'
  has_many :user_points_logs, as: :gamificable

  def pending?
    self.review_started_at == nil
  end

  def self.pending
    where(review_started_at: nil)
  end

  def being_reviewed?
    self.review_started_at != nil && self.accepted_at == nil && self.rejected_at == nil
  end

  def self.being_reviewed
    where.not(review_started_at: nil).where(accepted_at: nil, rejected_at: nil)
  end

  def rejected?
    self.rejected_at != nil
  end

  def self.rejected
    where.not(rejected_at: nil)
  end

  def accepted?
    self.accepted_at !=nil
  end

  def self.accepted
    where.not(accepted_at: nil)
  end
end
