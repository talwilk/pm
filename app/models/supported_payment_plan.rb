class SupportedPaymentPlan
  def self.all
    @all_payments ||= YamlLoader.load("supported_payment_plans.yml")
  end

  def self.collection
    all.map {|key| [I18n.t("payment_plans.#{key}"), key]}
  end

  def self.find(key)
    I18n.t("payment_plans.#{key}")
  end
end
