  class BaseContext
    include Interactor::CommonContext

    delegate :each_pair, to: :to_h

    def self.accessors
      %i(id uuid created_at updated_at error)
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

    def as_record
      to_h.except(:uuid, :created_at, :updated_at, :error)
    end
  end
