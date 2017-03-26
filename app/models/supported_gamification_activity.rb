class SupportedGamificationActivity
  def self.all
    @all_gamification_activities ||= YamlLoader.load("supported_gamification_activities.yml")
  end

  def self.find(key)
    all[key]
  end

  def self.description(key)
    I18n.t("gamification_activities.#{key}")
  end
end
