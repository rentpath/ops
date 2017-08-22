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
        @singleton ||= new
      end
    end

    def heartbeats
      @heartbeats ||= {}
    end

    def add(name, &block)
      heartbeats[name] = block
    end

    def check(name)
      return heartbeats[name.to_sym].call
    rescue StandardError => e
      puts "Error: #{e}\n#{e.backtrace[2..-1].join("\n")}" unless heartbeats[name.to_sym].nil?
      return false
    end
  end

  class << self
    def add_heartbeat(name, &block)
      Heartbeat.add name, &block
    end
  end
end
