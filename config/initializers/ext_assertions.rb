require "active_record/testing/query_assertions"

Rails.backtrace_cleaner.add_silencer { |line| line.match?(File.basename(__FILE__)) }

module ActiveRecord
  module Assertions
    module QueryAssertions
      def assert_queries_count_lteq(count, include_schema: false, &block)
        ActiveRecord::Base.lease_connection.materialize_transactions unless include_schema

        counter = SQLCounter.new
        ActiveSupport::Notifications.subscribed(counter, "sql.active_record") do
          result = _assert_nothing_raised_or_warn("assert_queries_count", &block)
          queries = include_schema ? counter.log_all : counter.log
          assert_operator queries.size, :<=, count, "#{count} or less queries expected, but #{queries.size} queries were executed."
          result
        end
      end
    end
  end
end
