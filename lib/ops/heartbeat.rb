module Ops
  class Heartbeat
    def heartbeats
      @heartbeats ||= {}
    end

    def add(name, &block)
      heartbeats[name] = block
    end

    def check(name = nil)
      status, text = 200, 'OK'
      if name
        begin
          heartbeats[name.to_sym].call
          text = "#{name} is OK"
        rescue
          status, text = 500, "#{name} does not have a heartbeat"
        end
      end
      { status: status, text: text }
    end
  end
end
