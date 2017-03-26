class SupportedFollowedBadge
  def self.all
    @all_followed_badges ||= YamlLoader.load("supported_followed_badges.yml")
  end

  def self.upgrade_moment(key)
    all[key]
  end

  def self.upgrade_level(upgrade_moment)
    all.key(upgrade_moment)
  end

  def self.find(key)
    I18n.t("followed_badges.#{key}")
  end
end
