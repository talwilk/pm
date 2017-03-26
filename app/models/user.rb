class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  acts_as_paranoid
  acts_as_voter

  has_many :dilemmas, dependent: :destroy
  has_many :advices, class_name: 'DilemmaAdvice', dependent: :destroy
  has_one :profile, class_name: 'UserProfile', inverse_of: :user
  has_many :guru_applications
  has_many :user_points_logs
  has_many :projects
  has_many :pros

  accepts_nested_attributes_for :profile, update_only: true

  before_create :set_username

  validates :role, presence: true, inclusion: { in: %w{regular guru} }
  validates :signup_way, presence: true, inclusion: { in: %w{regular guru} }
  validates_presence_of :profile

  delegate :full_name, to: :profile

  def guru?
    self.role == 'guru'
  end

  def country
    Country.find(country_iso)
  end

  def to_s
    full_name
  end

  def amount_of_likes
    amount = 0
    self.advices.each do |advice|
      amount += advice.votes_for.size
    end
    amount
  end

  private

  def set_username
    new_username = base_username = self.email.split('@').first
    count = 0

    loop do
      break unless User.with_deleted.find_by(username: new_username)

      count = count + 1
      new_username = base_username + count.to_s
    end

    self.username = new_username
    if self.profile.first_name.blank?
      self.profile.first_name = new_username
    end
  end
end
