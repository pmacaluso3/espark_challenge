module KeySanitizable
  def sanitize_key(key)
    key.downcase.gsub(' ', '_').to_sym
  end
end
