  class BaseContext
    include Interactor::CommonContext

    delegate :each_pair, to: :supplied_attributes

    def self.modifiable_attribute_names
      # Declare a whitelist of modifiable attributes
      []
    end

    def self.fixed_attribute_names
      %i(id uuid created_at updated_at error viewer)
    end

    def self.accessors
      fixed_attribute_names + modifiable_attribute_names
    end

    attr_accessor *accessors

    def initialize(args={})
      @keys = args.keys.map(&:to_sym)
      update(args)
    end

    def modifiable
      self
    end

    def update(args)
      args.each do |k, v|
        send("#{k}=", v)
      end
    end

    def full_attributes
      Hash[self.class.accessors.map { |a| [a, send(a)] }]
    end

    def modifiable_attributes
      # Enforce the whitelist
      supplied_attributes.slice(*self.class.modifiable_attribute_names)
    end

    def as_new_record
      supplied_attributes.except(*self.class.fixed_attribute_names)
    end

    private
    
    def supplied_attributes
      full_attributes.slice(*@keys)
    end
  end
