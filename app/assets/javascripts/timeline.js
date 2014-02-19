$(document).ready(function() {
  var timeline = $('#time_line');

  //grabbing the timeline data
  var source = JSON.parse(timeline.attr('data-timeline'));
  // Filtering down to the event objects
  var timeline_dates = source.timeline.date;
  var start_index = 0;
  var target_date = new Date(); //set whatever date you want as your start date
  for(x in timeline_dates) {
      var slide_date = new Date( timeline_dates[x].startDate );
      if( slide_date < target_date) start_index++;
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
