class SupportedExperienceTime
  def self.all
    @all_experiences ||= YamlLoader.load("supported_experience_times.yml")
  end

  def self.collection
    all.map { |key| [I18n.t("experience_times.#{key}"), key] }
  end

  def self.find(key)
    I18n.t("experience_times.#{key}")
  end
end
