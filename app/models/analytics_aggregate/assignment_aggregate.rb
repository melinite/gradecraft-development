class AnalyticsAggregate::AssignmentAggregate < AnalyticsAggregate
  field :assignment_id, type: Integer

  # assignment_id: 1,
  # total: %,
  # count: %,
  # average: %%,
  # users: {
  #   1: {
  #     events: {
  #       "predictor": {
  #         all_time: %,
  #         yearly: {
  #           key: {
  #             total: %,
  #             count: %,
  #             average: %%
  #           }
  #         },
  #         ...
  #       }
  #     }
  #   }
  # },
  # events: {
  #   "predictor": {
  #     all_time: %,
  #     yearly: {
  #       key: {
  #        total: %,
  #        count: %,
  #        average: %%
  #      }
  #     },
  #     ...
  #   }
  # }

  def self.incr(event)
    super
    # TODO: Increment cached average
  end

  def self.aggregate_scope(event)
    self.where(_type: "AnalyticsAggregate::AssignmentAggregate", assignment_id: event.assignment_id)
  end

  def self.upsert_hash(event)
    total = (event.data['score'].to_f / event.data['possible'].to_f)
    upsert_hash = Hash.new.tap do |hash|
      GRANULARITIES.each do |granularity, interval|
        user_key = ["users", event.user_id]
        event_key = ["events", event.event_type]
        granular_key = [granularity, self.time_key(event.created_at, interval)].compact

        hash[ (user_key + event_key + granular_key + ['total']).join('.') ] = total
        hash[ (user_key + event_key + granular_key + ['count']).join('.') ] = 1

        hash[ (event_key + granular_key + ['total']).join('.') ] = total
        hash[ (event_key + granular_key + ['count']).join('.') ] = 1
      end
    end
  end
end
