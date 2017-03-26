class LoginHistory < ActiveRecord::Base
  belongs_to :user, -> { with_deleted }
end
