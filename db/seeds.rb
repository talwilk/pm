IsoCountryCodes.for_select.each do |country_iso|
  Country.create(country_iso: country_iso[1])
end
Country.create(country_iso: "RD", enabled_at: Time.zone.now)

SuperAdmin.create!(email: "master@dilemma.guru", password: "password", full_name: "Super Admin")
