$(document).ready(function() {
  if ($('#time_line').length) {
    createStoryJS({
      type: 'timeline',
      width: '100%',
      height: '600',
      hash_bookmark: 'true',
      source: '/timeline.json', //get the events.json format from https://github.com/VeriteCo/TimelineJS#file-formats
      embed_id: 'time_line'
    });
  }
});
