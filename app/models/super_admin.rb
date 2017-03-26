class SuperAdmin < ActiveRecord::Base

  has_many :blog_posts, :class_name => 'Blog::Post'
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :full_name, presence: true

  acts_as_paranoid

  def to_s
    full_name
  end
end
