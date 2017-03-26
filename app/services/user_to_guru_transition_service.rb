class UserToGuruTransitionService
  attr_reader :user, :user_profile

  def initialize(user)
    @user = user
  end

  def call
    @user.update_attribute(:role, 'guru')
    @user.profile.update_attribute(:experience, 'less_than_1_year')
    @user.profile.category_list += ['handyman'] if @user.profile.category_list.size == 0
    @user.profile.save
  end
end
