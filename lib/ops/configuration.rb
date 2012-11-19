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

    def print_detail(object, indent = 0)
      output = ""
      if object.kind_of? Hash
       output << "{\n"
       output << object.collect { |key, value|
         "  " * indent + "  #{print_detail key} => #{print_detail value, indent+1}"
       }.join(",\n") << "\n"
       output << "  " * indent + "}"
      else
       output << object.inspect
      end
      output
    end
  end
end

