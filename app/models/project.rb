class Project < ActiveRecord::Base
	belongs_to :type
	belongs_to :user
	belongs_to :qna
	has_many :tasks
	has_many :pros

	validates :name, presence: true
	#validates :email, presence: true
end
