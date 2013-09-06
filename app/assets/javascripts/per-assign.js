$(function () {
  // set 'data-id' to the assignment ID on a div with id 'grades_per_assign' to generate chart
  if ($('#grades_per_assign').length) {
    var id = $('#grades_per_assign')[0].getAttribute('data-id');
    $.getJSON('/users/scores_for_single_assignment', { id: id }, function (data) {
      $('#grades_per_assign').sparkline(data.scores, {type: 'box', width: '100%', height: '40px' } );
    })
  }
})
