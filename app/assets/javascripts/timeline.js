$(document).ready(function() {
  var timeline = $('#time_line');

  //grabing the timeline data
  var source = JSON.parse(timeline.attr('data-timeline'));
  // Filtering down to the event objects
  var timeline_dates = source.timeline.date;

  //starting the slide count
  var start_index = 0;

  //setting the target date
  var target_date = new Date();

  // iterating through the dates
  for(var x in timeline_dates) {

    //setting the dates to a variable that will be parsed - this is because Safari and dates don't play nicely
    var st = timeline_dates[x].startDate;

    // Checking to make sure there is a date for the event - skipping it if not
    if (typeof st != "undefined") {
      //splitting the variable into pieces so we can reformat it for Safari
      var dt = st.split(/[^0-9]/);

      // Creating the date that we'll compare against
      var slide_date = new Date( dt[0], dt[1], dt[2] );

      // Comparing our current date against the slide date and increasing the slide count if it's before our goal
      if( slide_date < target_date) start_index++;

    }
    // and if we skipped it we need to count the slide anyways
    else {
      start_index++
    }

  }

  if (timeline.length) {
    //get the events.json format from https://github.com/VeriteCo/TimelineJS#file-formats
    createStoryJS({
      type: 'timeline',
      width: '100%',
      height: '600',
      hash_bookmark: 'true',
      source: source,
      embed_id: 'time_line',
      start_at_slide: start_index
    });
  }
});
