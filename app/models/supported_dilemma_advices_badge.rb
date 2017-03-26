class SupportedDilemmaAdvicesBadge
  def self.all
    @all_dilemma_advices_badges ||= YamlLoader.load("supported_dilemma_advices_badges.yml")
  end

  def self.upgrade_moment(key)
    all[key]
  end

  def self.upgrade_level(upgrade_moment)
    all.key(upgrade_moment)
  end

  def self.find(key)
    I18n.t("dilemma_advices_badges.#{key}")
  end
end
