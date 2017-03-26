class Task < ActiveRecord::Base
	belongs_to :project
	belongs_to :pro

	has_many :dilemmas
end
