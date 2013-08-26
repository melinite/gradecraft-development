$(document).ready(function() {
    createStoryJS({
      type: 'timeline',
      width: '100%',
      height: '600',
      hash_bookmark: 'false',
      source: 'timeline.json', //get the events.json format from https://github.com/VeriteCo/TimelineJS#file-formats
      embed_id: 'time_line'
    });
  });