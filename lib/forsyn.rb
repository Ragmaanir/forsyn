require 'logger'
require 'active_support'
require 'active_support/core_ext'

require 'eventmachine'
require 'em-synchrony'
require 'em-synchrony/em-http'
require 'elasticsearch-transport'
require 'elasticsearch/api'

require 'forsyn/version'

require 'forsyn/example_setup'
require 'forsyn/alert_state'

require 'forsyn/streams/stream'
require 'forsyn/streams/filter'
require 'forsyn/streams/splitter'
require 'forsyn/streams/rate_limiter'
require 'forsyn/streams/change_detector'
require 'forsyn/streams/printer'
require 'forsyn/streams/sink'

require 'forsyn/buffered_dispatcher'

require 'forsyn/event_backends/backend'
require 'forsyn/event_backends/elasticsearch_backend'
require 'forsyn/tls_server'

module Forsyn

  mattr_reader :logger

  @@logger = Logger.new(STDOUT)

  def initialize(logger: Logger.new(STDOUT))
    @logger = logger
  end

end

# e = Forsyn::ExampleSetup.new

# e.analyze(OpenStruct.new(
#   "time"=>"2015-05-07 22:42:05 UTC",
#   "type"=>"machine.memory",
#   "total"=>8_176_716_000,
#   "used"=>7_284_544_000,
#   "free"=>892_172_000
# ))

# e.analyze(OpenStruct.new(
#   "time"=>"2015-05-07 22:42:05 UTC",
#   "type"=>"machine.memory",
#   "total"=>8_176_716_000,
#   "used"=>7_284_544_000,
#   "free"=>1_892_172_000
# ))

if ENV['FORSYN_ENV'] != 'test'
  Forsyn::TlsServer.new.run
end
