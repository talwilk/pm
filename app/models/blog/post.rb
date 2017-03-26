class Blog::Post < ActiveRecord::Base
  belongs_to :super_admin, :foreign_key => :user_id
  mount_uploader :cover_image, BlogCoverImageUploader

  validates :title, presence: true
  validates :content, presence: true
end
