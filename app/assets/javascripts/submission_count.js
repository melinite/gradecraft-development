/** Submission Count **/

$(function () {
  // set 'data-id' to the assignment ID on a div with id 'grades_per_assign' to generate chart
  if ($('.levels_per_assign').length) {
    $('.levels_per_assign').each( function (index) {
      var div = $( this )
      var id = $('.levels_per_assign')[index].getAttribute('data-id');
      $.getJSON('/students/scores_for_single_assignment', { id: id }, function (data) {
        div.sparkline(data.scores, {type: 'box', boxFillColor: '#eee', lineColor: '#333', boxLineColor: '#333', whiskerColor: '#333', outlierLineColor: '#333',
outlierFillColor: '#F4A425', spotRadius: '10', medianColor: '#0D9AFF', height: '35', width: '300' } );
      })
    })
  }
})
