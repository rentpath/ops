module Ops
  class Config
    def initialize(data = {})
      @data = {}
      update!(data)
    end

    def update!(data)
      data.each do |key, value|
        self[key] = value
      end
    end

    def [](key)
      @data[key.to_sym]
    end

    def []=(key, value)
      @data[key.to_sym] = if value.instance_of?(Hash)
                            Config.new(value)
                          else
                            value
                          end
    end

    def method_missing(sym, *args) # rubocop:disable Style/MissingRespondToMissing
      if sym.to_s =~ /(.+)=$/
        self[Regexp.last_match(1)] = args.first
      else
        self[sym]
      end
    end
  end

  class << self
    attr_accessor :config

    def setup
      self.config ||= Config.new
      yield config
    end
  end
end
