//
  var sparkOpts = {
    type: 'box',
    width: '80%',
  };

  if ($('#grade_distro').length) {
    $.getJSON('/students/scores_for_current_course.json', function (data) {
      sparkOpts.height = '150px';
      $('#grade_distro').sparkline(data.scores, sparkOpts);
    })
  }

  if ($('#student_grade_distro').length) {
    var data = JSON.parse($('#student_grade_distro').attr('data-scores'));
    if (data !== null) {
      sparkOpts.target = data.user_score[0];
      sparkOpts.tooltipOffsetY = -130;
      sparkOpts.height = '35';
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
      $('#student_grade_distro').sparkline(data.scores, sparkOpts);
    }
  }

  var sparkResize;

  $(window).resize(function(e) {
      clearTimeout(sparkResize);
      sparkResize = setTimeout(sparkOpts, 500);
  });