class BaseContext
  include Interactor::CommonContext

  delegate :each_pair, to: :to_hash

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

  def includes?(key)
    @keys.include?(key)
  end

  def supplied_attributes
    to_hash.slice(*@keys)
  end

  def to_hash
    Hash[self.class.attributes.map { |a| [a, send(a)] }]
  end
  alias_method :to_h, :to_hash

  module ClassMethods
    def inputs(*attrs)
      @inputs ||= []
      @inputs += attrs
      @inputs.uniq!

      attr_accessor *attributes
    end

    def outputs(*attrs)
      @outputs ||= []
      @outputs += attrs
      @outputs.uniq!

      attr_accessor *attributes
    end

    def attributes
      (common_attributes + (@inputs || []) + (@outputs || [])).uniq
    end

    def common_attributes
      [:error]
    end
  end
  extend ClassMethods
end
