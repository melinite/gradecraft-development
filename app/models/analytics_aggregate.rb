class AnalyticsAggregate
  include Mongoid::Document

  GRANULARITIES = {
    :all_time => nil,
    :yearly => 1.year.to_i,
    :monthly => 1.month.to_i,
    :weekly => 1.week.to_i,
    :daily => 1.day.to_i,
    :hourly => 1.hour.to_i,
    :minutely => 1.minute.to_i
  }

  field :_type, type: String
  field :users, type: Hash
  field :events, type: Hash

  # t = event.created_at
  # interval = GRANULARITIES[granularity]
  # key = ( t.to_i / interval ) * interval
  # % = count
  #
  # users: {
  #   1: {
  #     events: {
  #       "predictor": {
  #         all_time: %,
  #         yearly: {
  #           key: %
  #         },
  #         monthly: {
  #           key: %
  #         },
  #         weekly: {
  #           key: %
  #         },
  #         daily: {
  #           key: %
  #         },
  #         hourly: {
  #           key: %
  #         },
  #         minutely: {
  #           key: %
  #         }
  #       }
  #     }
  #   }
  # },
  # events: {
  #   "predictor": {
  #     all_time: %,
  #     yearly: {
  #       key: %
  #     },
  #     monthly: {
  #       key: %
  #     },
  #     weekly: {
  #       key: %
  #     },
  #     daily: {
  #       key: %
  #     },
  #     hourly: {
  #       key: %
  #     },
  #     minutely: {
  #       key: %
  #     }
  #   }
  # }

  def self.incr(event)
    self.aggregate_scope(event).find_and_modify(self.modify(event), {'upsert' => 'true', :new => true})
  end

  def self.aggregate_scope(event)
    self.where(_type: 'AnalyticsAggregate').first
  end

  def self.modify(event)
    {'$inc' => upsert_hash(event)}
  end

  def self.upsert_hash(event)
    upsert_hash = Hash.new.tap do |hash|
      GRANULARITIES.each do |granularity, interval|
        user_key = ["users", event.user_id]
        event_key = ["events", event.event_type]
        granular_key = [granularity, self.time_key(event.created_at, interval)].compact

        hash[ (user_key + event_key + granular_key).join('.') ] = 1
        hash[ (event_key + granular_key).join('.') ] = 1
      end
    end
  end

  # t = Time.now.to_i     #=> 1377704456
  # key(t, 1.year.to_i)   #=> 1356976800
  # key(t, 1.month.to_i)  #=> 1376352000
  # key(t, 1.week.to_i)   #=> 1377129600
  # key(t, 1.day.to_i)    #=> 1377648000
  # key(t, 1.hour.to_i)   #=> 1377702000
  # key(t, 1.minute.to_i) #=> 1377704400
  # key(t, nil)           #=> nil
  def self.time_key(time, interval)
    interval && ( time.to_i / interval ) * interval
  end
end
