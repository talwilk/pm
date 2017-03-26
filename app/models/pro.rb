class Pro < ActiveRecord::Base
	belongs_to :project
	belongs_to :user
	has_many :tasks

	def full_name
    "#{first_name} #{last_name}"
  end
end
