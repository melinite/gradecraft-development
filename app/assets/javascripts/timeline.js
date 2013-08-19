$(document).ready(function() {
    createStoryJS({
      type: 'timeline',
      width: '700',
      height: '600',
      hash_bookmark: 'false',
      debug: 'true',
      source: '/courses/1/timeline.json', //get the events.json format from https://github.com/VeriteCo/TimelineJS#file-formats
      embed_id: 'time_line'
    });
  });