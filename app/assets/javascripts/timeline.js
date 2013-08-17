$(document).ready(function() {
    createStoryJS({
      type: 'timeline',
      width: '100%',
      height: '500',
      hash_bookmark: 'true',
      debug: 'true',
      source: '/assignments.json', //get the events.json format from https://github.com/VeriteCo/TimelineJS#file-formats
      embed_id: 'time_line'
    });
  });