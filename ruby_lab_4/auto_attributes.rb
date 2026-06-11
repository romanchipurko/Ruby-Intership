# frozen_string_literal: true

require_relative 'validation_error'

module AutoAttributes
  def setup_attributes(args = {})
    args.each do |key, value|
      instance_variable_set("@#{key}", value)

      self.class.define_method key do
        instance_variable_get("@#{key}")
      end

      self.class.define_method "#{key}=" do |value|
        raise ValidationError if (key == :id || key == :title) && value.nil?

        instance_variable_set("@#{key}", value)
      end
    end
  end
end
