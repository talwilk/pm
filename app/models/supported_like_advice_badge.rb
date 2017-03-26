class SupportedLikeAdviceBadge
  def self.all
    @all_like_advice_badges ||= YamlLoader.load("supported_like_advice_badges.yml")
  end

  def self.upgrade_moment(key)
    all[key]
  end

  def self.upgrade_level(upgrade_moment)
    all.key(upgrade_moment)
  end

  def self.find(key)
    I18n.t("like_advice_badges.#{key}")
  end
end
