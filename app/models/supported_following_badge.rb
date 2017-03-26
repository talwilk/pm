class SupportedFollowingBadge
  def self.all
    @all_following_badges ||= YamlLoader.load("supported_following_badges.yml")
  end

  def self.upgrade_moment(key)
    all[key]
  end

  def self.upgrade_level(upgrade_moment)
    all.key(upgrade_moment)
  end

  def self.find(key)
    I18n.t("following_badges.#{key}")
  end
end
