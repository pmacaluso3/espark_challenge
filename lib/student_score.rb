require 'ostruct'
class StudentScore < OpenStruct
  include KeySanitizable

  def initialize(args = {})
    sanitized_args = {}
    args.each do |k, v|
      sanitized_args[sanitize_key(k)] = v
    end
    super(sanitized_args)
  end
end
