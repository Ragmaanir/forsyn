ENV['FORSYN_ENV'] = 'test'

require "forsyn"
require 'wrong'
require 'timecop'

include Wrong

def at(t, &block)
  Timecop.freeze(t, &block)
end
