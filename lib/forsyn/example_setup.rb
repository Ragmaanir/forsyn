module Forsyn
  class ExampleSetup
    def initialize
      @free_mem_check = Checkers::ThresholdChecker.new(
        "test",
        direction: :downwards,
        abnormal: 1_000_000_000,
        critical: 500_000_000
      )

      @free_mem_responder = Responders::ImmediateResponder.new
      @term_notifier = Notifiers::TerminalNotifier.new

      @free_mem_responder.input_from(@free_mem_check)
      @free_mem_responder.output_to(@term_notifier)

      @mapping = {
        "machine.memory" => {
          free: @free_mem_check
        }
      }
    end

    def analyze(sample)
      checks = @mapping[sample.type]

      checks.each do |field, checker|
        checker.check(sample, field)
      end if checks
    end

  private

    def each_mapping
      raise 'deprecated'
      hash_stack = [@mapping]
      keys_stack = [@mapping.keys]
      full_key = []

      while !hash_stack.empty?
        while !keys_stack.last.empty?
          h = hash_stack.last
          k = keys_stack.last.pop

          if h[k].is_a?(Hash)
            hash_stack.push(h[k])
            keys_stack.push(h[k].keys)
          else
            yield(full_key + [k])
          end
        end

        keys_stack.pop
      end

      hash_stack.pop
    end

    def lookup(keys, hash)
      value = hash

      while k = keys.pop
        value = value[k]
      end

      value
    end

  end
end

[
  {
    "time"=>"2015-05-07 22:42:05 UTC",
    "type"=>"machine.memory",
    "total"=>"8176716",
    "used"=>"7284544",
    "free"=>"892172"
  },
  {
    "time"=>"2015-05-07 22:42:05 UTC",
    "type"=>"machine.disk",
    "disks"=>[
      {
        "fs"=>"/dev/sdb5",
        "size"=>"19",
        "used"=>"11",
        "mount"=>"/"
      },
      {
        "fs"=>"none",
        "size"=>"4",
        "used"=>"0",
        "mount"=>"/sys/fs/cgroup"
      },
      {
        "fs"=>"udev",
        "size"=>"3",
        "used"=>"4",
        "mount"=>"/dev"
      },
      {
        "fs"=>"tmpfs",
        "size"=>"799",
        "used"=>"1",
        "mount"=>"/run"
      },
      {
        "fs"=>"none",
        "size"=>"5",
        "used"=>"0",
        "mount"=>"/run/lock"
      },
      {
        "fs"=>"none",
        "size"=>"3",
        "used"=>"32",
        "mount"=>"/run/shm"
      },
      {
        "fs"=>"none",
        "size"=>"100",
        "used"=>"16",
        "mount"=>"/run/user"
      },
      {
        "fs"=>"/dev/sdb6",
        "size"=>"19",
        "used"=>"14",
        "mount"=>"/home"
      },
      {
        "fs"=>"/dev/sdc5",
        "size"=>"1",
        "used"=>"1",
        "mount"=>"/media/storage-linux"
      }
    ]
  }
]
