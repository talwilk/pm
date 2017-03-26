class Country < ActiveRecord::Base
  self.primary_key = :country_iso

  def to_s
    if country_iso == 'RD'
      I18n.t("countries.#{country_iso}")
    else
      I18n.t(country_iso, :scope => :countries)
    end
  end
end
