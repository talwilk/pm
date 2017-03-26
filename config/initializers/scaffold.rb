Rails.application.config.generators do |g|
  g.test_framework  :rspec, fixture: false,
                    :view_specs => false,
                    :controller_specs => true,
                    :request_specs => false,
                    :routing_specs => false
  g.fixture_replacement :factory_girl, :dir => 'spec/factories'
  g.stylesheets     false
  g.javascripts     false
  g.helper     false
end
