$(document)
  .delegate('#per-student-select', 'change', function(e) {
    var $select = $(this);
    $('#per-student-analytics [data-chart]').each( function() {
      var $this = $(this),
          urlData = $this.data('url-data'),
          userParam = 'user_id=' + $select.val();
      $this.data('url-data', $.grep([urlData, userParam],function(n){ return(n) }).join('&'));
      refreshAnalytics.call(this);
    });
  });
