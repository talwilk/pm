class SupportedCity
  def self.all
    all_cities
  end

  def self.collection
    all.map {|key| [I18n.t("cities.#{key}"), key]}
  end

  def self.find(key)
    OpenStruct.new({name: I18n.t("cities.#{key}")})
  end

  private

  def self.all_cities
    YAML.load_file(Rails.root.join('config/supported_cities.yml'))
  end
end
