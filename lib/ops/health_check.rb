module Ops
  class HealthCheck
    class << self
      def check!
        dependencies = Ops.config.dependencies.data rescue {}
        status = Hash[dependencies.map{|k,v| [k, v.call] }]
        [status.values.all?, status]
      rescue StandardError => e
        [false, exception: e.message]
      end
    end
  end
end