$(document).ready(function() {
  var timeline = $('#time_line');
  if (timeline.length) {
    //get the events.json format from https://github.com/VeriteCo/TimelineJS#file-formats
    var source = JSON.parse(timeline.attr('data-timeline'));
    createStoryJS({
      type: 'timeline',
      width: '100%',
      height: '600',
      hash_bookmark: 'true',
      source: source,
      embed_id: 'time_line'
    });
  }
});
