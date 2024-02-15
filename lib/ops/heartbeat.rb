module Ops
  class Heartbeat
    class << self
      def add(name, &block)
        instance.add name, &block
      end

      def check(name)
        instance.check(name)
      end

      def instance
        @instance ||= new
      end
    end

    def heartbeats
      @heartbeats ||= {}
    end

    def add(name, &block)
      heartbeats[name] = block
    end

    def check(name)
      heartbeats[name.to_sym].call
    rescue StandardError => e
      puts "Error: #{e}\n#{e.backtrace[2..].join("\n")}" unless heartbeats[name.to_sym].nil?
      false
    end
  end

  class << self
    def add_heartbeat(name, &block)
      Heartbeat.add name, &block
    end
  end
end
