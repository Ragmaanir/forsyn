require 'net/smtp'

module Forsyn
  class Mailer
    def initialize(server)
      @server = server
    end

    def send(from:, to:, subject:, body:, from_alias: nil)
      msg = <<-MAIL
From: #{from_alias} <#{from}>
To: <#{to}>
Subject: #{subject}

#{body}
      MAIL

      Net::SMTP.start(server) do |smtp|
        smtp.send_message(msg, from, to)
      end
    end
  end
end
