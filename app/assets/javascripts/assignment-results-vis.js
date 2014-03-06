//
  var sparkOpts = {
    type: 'box',
    width: '100%',
  };

  if ($('.grades_per_assign').length) {
    var data = JSON.parse($('.grades_per_assign').attr('data-scores'));
    if (data !== null) {
      sparkOpts.tooltipOffsetY = -130;
      sparkOpts.height = '35';
      sparkOpts.width = '200';
      sparkOpts.tooltipOffsetY = -80;
      sparkOpts.targetColor = "#FF0000";
      sparkOpts.boxFillColor = '#eee';
      sparkOpts.lineColor = '#333';
      sparkOpts.boxLineColor = '#333';
      sparkOpts.whiskerColor = '#333';
      sparkOpts.outlierLineColor = '#333';
      sparkOpts.outlierFillColor = '#F4A425';
      sparkOpts.spotRadius = '10';
      sparkOpts.medianColor = '#0D9AFF';
      $('.grades_per_assign').sparkline(data, sparkOpts);
    }
  }

  var sparkResize;

  $(window).resize(function(e) {
      clearTimeout(sparkResize);
      sparkResize = setTimeout(sparkOpts, 500);
  });

  $('#myStat').circliful();