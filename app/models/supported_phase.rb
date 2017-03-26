class SupportedPhase
  def self.all
    all_phases
  end

  def self.collection
    all.map {|key| [I18n.t("phases.#{key}"), key]}
  end

  def self.find(key)
    OpenStruct.new({name: I18n.t("phases.#{key}")})
  end

  private

  def self.all_phases
    YAML.load_file(Rails.root.join('config/supported_phases.yml'))
  end
end
