module KeySanitizable
  NON_NUMERIC_SCORES = { 'K' => 0 }

  def sanitize_key(key)
    key.downcase.gsub(' ', '_').to_sym
  end

  def convert_non_numeric_score(score)
    NON_NUMERIC_SCORES[score] || score.to_i
  end
end
