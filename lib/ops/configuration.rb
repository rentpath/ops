module Ops
  class Configuration
    def configuration
      @configuration ||= {}
    end

    def add_section(name, &block)
      configuration[name] = block
    end

    def current
      configuration.inject({}) do |current, (section, block)|
        current[section] = block.call
        current
      end
    end
  end
end

