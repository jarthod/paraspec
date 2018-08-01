require 'rspec/core'

module Paraspec
  class WorkerFormatter
    RSpec::Core::Formatters.register self,
      #:start,
      :example_group_started,
      :example_started,
      :example_passed,
      :example_failed,
      :example_pending,
      :message,
      :stop,
      :start_dump,
      :dump_pending,
      :dump_failures,
      :dump_summary,
      :seed,
      :close

    def initialize(output)
      @master_client = output.master_client
    end

    def start(notification)
      # Worker formatter receives start notification for each example
      # that it receives from supervisor.
      # The start notification contains number of examples to be executed,
      # and the load time.
      # The number of examples isn't useful because this is a subset of
      # all of the examples to be run, and we can't wait to receive
      # start notifications from all workers in the master thus
      # start notifications are not aggregatable.
      # Loading time is something that master can figure out on its own.
      # Therefore we do not forward start notifications to master.
      # At the same time master must create and send start notifications
      # to its own formatters, for example the junit formatter
      # requires a start notification for the summary report to work.
    end

    def stop(notification)
      #p notification
    end

    def dump_summary(notification)
      #byebug
    end

    def method_missing(m, args)
      #p m
    end

    def example_started(notification)
    end

    def example_passed(notification)
    #byebug
      example_notification(notification)
    end

    def example_notification(notification)
      spec = {
        file_path: notification.example.metadata[:file_path],
        scoped_id: notification.example.metadata[:scoped_id],
      }
      #byebug
      #p :a
      execution_result = notification.example.execution_result
      @master_client.request('example-passed',
        spec: spec, result: execution_result)
      #b :b
      #1
    end

    def example_failed(notification)
      example_notification(notification)
    end

    def example_pending(notification)
      example_notification(notification)
    end
  end
end
