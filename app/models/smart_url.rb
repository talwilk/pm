class SmartUrl
  def self.normalize(url, protocol)
    return if url.blank?

    if url !~ /\Ahttps?:\/\//
      "#{protocol}://#{url}"
    else
      url
    end
  end
end
