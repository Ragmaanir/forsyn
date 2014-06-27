module Forsyn
  class EmailNotifier

    MAILER = Mailer.new('localhost')

    def notify(notification)
      mailer.send(
        from:       from,
        from_alias: ''
        to:         to,
        subject:    '',
        body:       email_body_from(notification)
      )
    end

  private

    def mailer
      MAILER
    end

  end
end
