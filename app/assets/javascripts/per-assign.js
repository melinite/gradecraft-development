$(function () {
  // set 'data-id' to the assignment ID on a div with id 'grades_per_assign' to generate chart
  if ($('.grades_per_assign').length) {
    $('.grades_per_assign').each( function (index) {
      var div = $( this )
      var id = $('.grades_per_assign')[index].getAttribute('data-id');
      $.getJSON('/students/scores_for_single_assignment', { id: id }, function (data) {
        div.sparkline(data.scores, {type: 'box', width: '300px', height: '30px', boxFillColor: '#eee'} );
      })
    })
  }
})
