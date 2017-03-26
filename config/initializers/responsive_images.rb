ResponsiveImages.configure do |config|
  # Set the default version for image. If you leave it at :default then it will use
  # the original size, i.e., image.url or you can use a specific version
  config.default = :desktop
  # Add some custom sizes that you'll generate with Carrierwave. You can make as many
  # as you want. But you'll need to configure mobvious for any custom ones.
  config.sizes = {
    mobile: :mobile,            # carrierwave version size
    desktop: :desktop           # and one more version...
  }
end
