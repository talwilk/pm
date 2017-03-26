class SupportedStatus
  def self.all
    all_statuses
  end

  def self.collection
    all.map {|key| [I18n.t("statuses.#{key}"), key]}
  end

  def self.find(key)
    OpenStruct.new({name: I18n.t("statuses.#{key}")})
  end

  private

  def self.all_statuses
    YAML.load_file(Rails.root.join('config/supported_statuses.yml'))
  end
end
