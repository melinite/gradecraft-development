# Analytics

GradeCraft includes analytics useful for staff to monitor and analyze
app usage for their course. To view analytics, when logged in as a staff
member, visit `/analytics` in the app.

## Processing and Storage

The analytics built into GradeCraft use MongoDB to store aggregate
analytics data over time.

Aggregate data is pre-processed from events sent by the app, to ensure
quick interaction when viewing analytics data in the analytics dashboard
and to maximize scalability.

For more background, [see discussion and links
here](https://github.com/bellotastudios/gradecraft-development/issues/108).

MongoDB was chosen for its document-based storage structure and quick
nested upsert functionality.

Document-based storage allows for efficient
writing and reading of nested data structures in a way that's easily
readable and understood. It may be possible to replace MongoDB using
Postgres's HStore in PostgreSQL 9.2 or later, or its JSON store in
PostgreSQL 9.3 or later, if desired.

Nested upsert functionality makes it possible to construct a nested hash
of values to be incremented (e.g. for several time-based buckets) in a
single command without having to do separate queries to see if a given
nested hash key already exists or to query the value in order to
increment it. This makes writing value-increments from events very quick
and efficient, even for multiple granularities at once.

## Granularity

All aggregate data is stored in multiple granularities (yearly, monthly,
weekly, daily, hourly, and minutely). For example, when a new event
comes in, it increments tracked aggregate values for the current year,
month, week, day, hour, and minute.

This makes it trivial to quickly query e.g. all values aggregated by
hour for some time range.

## Creating New Analytics Aggregate

To create a new aggregate (i.e. something to be tracked and graphed),
simply create a new class in `app/analytics_aggregates` with the
following data:

```
class MyNewAggregate
  include Analytics::Aggregate
 
  # One or more fields specific to this aggregate,
  # should at minimum include the field being scoped by.
  field :course_id, type: Integer 
  field :events, type: Hash
  
  scope_by :course_id             

  increment_keys "events.%{event_type}.%{granular_key}" => 1,
                 "events._all.%{granular_key}" => 1
end
```

## `scope_by`

The `scope_by` is a comma-separated list of collection keys to scope
aggregates by. This can be thought of as the overall scope to filter
results when viewing the graphed data as a user. At the very least, any
data viewed by staff in GradeCraft should be scoped by course or
something that belongs to course (e.g. assignment).

The scope must be included as a field in the class, though other data
keys (e.g. `events` in the example above) may but don't need to be.

## `increment_keys`

This is a hash of values to increment, where the key is the key name of
the value to be incremented in the Mongo collection (and may be nested).

The key string may contain variables using `%{}` notation. The variables
will be replaced at the time the upsert happens. The available variables
are any of the attributes on the triggered event. In the example above,
`event_type` will call `event.event_type` when the aggregate is
triggered by the event.

In addition to the attributes of the event, the variable `granular_key`
is also provided. When used, it will actually loop through all
granularities and replace them with the appropriate time-keys. I.e.
`"events._all.%{granular_key}"` above will actually upsert the
following:

```
{
  "events._all.all_time" => 1,
  "events._all.yearly.1356976800" => 1,
  "events._all.monthly.1376352000" => 1,
  "events._all.weekly.1377129600" => 1,
  "events._all.daily.1377648000" => 1,
  "events._all.hourly.1377702000" => 1,
  "events._all.minutely.1377704400" => 1
}
```

The value for each key in the `increment_keys` hash is the value by
which to increment each time an event is sent. For simple count
aggregates (e.g. logging the number of that event type to occur in each
granularity), it may be a simple number (the example above increments
the count by 1 each time an event happens).

The value may also be something more complex (e.g. an average or other
calculation) using a lambda:

```
increment_keys "%{granular_key}.average" => lambda { |event| event.actual.to_f / event.some_possible }
```

In addition to the event triggering the aggregate increment, the lambda
may also be called with the granularity and interval passed to the
lambda context (useful for e.g. frequency or rate calculations):

```
increment_keys "%{granular_key}.rate" => lambda { |event, granularity, interval|
  interval / (event.this_time - event.last_time)
}
```

*Don't pass the granularity and interval to the lambda unless needed, as
 it's less efficient, since it must be calculated in each time the
 increment method loops through the granularities, whereas a lambda that
 only needs the event is calculated and cached once for all 
 granularities.*

## Displaying Aggregate Data

To display an aggregate's data, call its `data` method, e.g.
`MyNewAggregate.data`.

The `data` method takes 4 arguments:
`(granularity, range, scope, and select_keys)`

More documentation to come. See
`/app/controllers/analytics_controller.rb` for examples.
