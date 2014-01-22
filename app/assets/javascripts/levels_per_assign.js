$(function () {
  // set 'data-id' to the assignment ID on a div with id 'grades_per_assign' to generate chart
  if ($('.levels_per_assign').length) {
    $('.levels_per_assign').each( function (index) {
      var div = $( this )
      var id = $('.levels_per_assign')[index].getAttribute('data-id');
      $.getJSON('/students/scores_for_single_assignment', { id: id }, function (data) {
        div.sparkline(data.scores, {type: 'pie', height: '50', width: '300' } );
      })
    })
  }
})
