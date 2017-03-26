class SupportedCategory
  def self.all
    @all_categories ||= YamlLoader.load("supported_categories.yml")
  end

  def self.collection
    all.map { |key| [I18n.t("categories.#{key}"), key] }
  end

  def self.my_dilemmas
    all.map { |key| [I18n.t("my_dilemmas.#{key}"), key] }
  end

  def self.all_dilemmas
    all.map { |key| [I18n.t("all_dilemmas.#{key}"), key] }
  end

  def self.find(key)
    OpenStruct.new({ name: I18n.t("categories.#{key}") })
  end
end
