class SupportedUserLevel
  def self.all
    @all_levels ||= YamlLoader.load("supported_user_levels.yml")
  end

  def self.find(key)
    I18n.t("user_levels.#{key}")
  end

  def self.upgrade_moment(key)
    all[key]
  end

  def self.upgrade_level(upgrade_moment)
    all.key(upgrade_moment)
  end

  def self.last_level
    all.keys.last
  end
end
