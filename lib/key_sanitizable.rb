module KeySanitizable
  NON_NUMERIC_SCORES = { 'K' => 0 }

  def sanitize_key(key)
    key.downcase.gsub(' ', '_').to_sym
  end

  def convert_non_numeric_score(score)
    if NON_NUMERIC_SCORES[score]
      NON_NUMERIC_SCORES[score]
    else
      score.to_i
    end
  end
end
