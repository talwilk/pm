class Medium < ActiveRecord::Base
  belongs_to :mediable, polymorphic: true, inverse_of: :media
  mount_uploader :file, MediaUploader
  acts_as_paranoid

  before_save :youtube_string

  def youtube_string
    if !self.youtube_url.blank?
      a = self.youtube_url.split('//').last.split('/')
      b = a.last.split('watch?v=').last.split('?').first.split('&').first
      if a[1] == 'p'
        self.youtube_url = "p/#{b}"
      else
        self.youtube_url = b
      end
    end
  end
end
