class YamlLoader
  def self.load(filename)
    if Rails.env.test?
      YAML.load_file(Rails.root.join("spec", "fixtures", "test-yml", "test_#{filename}"))
    else
      YAML.load_file(Rails.root.join("config", filename))
    end
  end
end
