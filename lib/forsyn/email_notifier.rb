module Forsyn
  class EmailNotifier

    MAILER = Mailer.new('localhost')

    attr_reader :mailer, :from, :to

    def initialize(from:, to:, mailer: MAILER)
      @mailer = mailer
      @from = from
      @to = to
    end

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

    def email_body_from(notification)
      notification[:message]
    end

  end
end
