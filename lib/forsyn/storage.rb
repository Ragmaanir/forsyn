require 'moped'

module Forsyn
  class Storage

    attr_reader :session

    def initialize(hosts: ["127.0.0.1:27017"], name: nil, password: nil)
      @session = Moped::Session.new(hosts)
      @session.login(name, password) if password
    end

    def store(event)
      session[:events].insert(event)
    end

  end
end
