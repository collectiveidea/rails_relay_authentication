  class BaseContext
    include Interactor::CommonContext

    def self.accessors
      %i(id uuid created_at updated_at)
    end

    attr_accessor *accessors

    def initialize(args={})
      @keys = args.keys
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

    def to_h
      Hash[@keys.map { |a| [a, send(a)] }]
    end
  end
