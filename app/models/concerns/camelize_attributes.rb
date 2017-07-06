module CamelizeAttributes
  extend ActiveSupport::Concern

  module ClassMethods
    def camelize_attribute(attr)
      attr = attr.to_s
      camelized_attr = attr.camelize(:lower)
      return if camelized_attr == attr
      
      define_method(camelized_attr) do
        send(attr)
      end
      
      define_method("#{camelized_attr}=") do |value|
        send("#{attr}=", value)
      end
    end

    def camelize_attributes(*attrs)
      attrs.each do |attr|
        camelize_attribute attr
      end
    end
  end
end