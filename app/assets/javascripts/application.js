// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.omniselect
//= require jquery.sparkline.min
//= require jquery.fileupload
//= require s3_direct_upload
//= require jquery.ui.widget
//= require jquery.sparkline.min
//= require underscore.min
//= require backbone.min
//= require best_in_place
//= require best_in_place.purr
//= require bootstrap
//= require bootstrap-datetimepicker
//= require jquery.dynatable
//= require gradecraft
//= require preload_store
//= require selectToUISlider.jQuery
//= require_self
//= require analytics
//= require analytics_dashboard
//= require assignment_types
//= require assignments
//= require grade_schemes
//= require nested_fields
//= require users
//= require grade_schemes
//= require user_dashboard
//= require submissions
//= require submission_file
//= require timelineJS/embed
//= require timeline
//= require stupidtable
//= require earned_badges
//= require predictor
//= require per-assign 
$(document).ready(function(){

  $('#gradeCurious').popover();

  $('collapse').collapse('toggle');

  $('#toDoList').collapse('hide');

  $('#courseInfo').collapse('hide');

  $('#badgesInfo').collapse('hide');

  $('#academicInfo').collapse('hide');

  $('#gradeDistro').collapse('hide');

  $('#myModal').modal('hide');

  $(".alert").alert();

  $('.datetimepicker').datetimepicker()
  if ($('.s3_uploader').length) {
    $('.s3_uploader').S3Uploader({
      allow_multiple_files: false,
      remove_completed_progress_bar: false,
      progress_bar_target: $('.s3_progress')
    })
    $('.s3_uploader').bind('s3_upload_complete', function (e, content) {
      if ($('.s3_files').first().val()) {
        var field = $('.s3_files').first().clone()
        $('.s3_files').parent().append(field)
        $('.s3_files').last().val(content.filepath)
      } else {
        $('.s3_files').val(content.filepath)
      }
      $('#uploaded_files').append('<br /> ' + content.filename)
    })

    $('s3_uploader').bind('s3_upload_failed', function (e, content) {
      alert(content.filename +' failed to upload: ' + content.error_thrown)
    })
  }

  $('#predictorUsage').tooltip('show');

  var table = $(".simpleTable").stupidtable({
    // Sort functions here
  });

  table.bind('aftertablesort', function (event, data) {
    // data.column - the index of the column sorted after a click
    // data.direction - the sorting direction (either asc or desc)

    var th = $(this).find("th");
    th.find(".arrow").remove();
    var arrow = data.direction === "asc" ? "↑" : "↓";
    th.eq(data.column).append('<span class="arrow">' + arrow +'</span>');
  });

  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

  $("a[rel=popover]").popover();
  $('.tooltip, a[rel="tooltip"]').tooltip();

	$('#navbar').affix();

  // Temporarily commented out to revive dashboard charts & predictor

  $('.slider').each(function(i,slider) {
    $slider = $(slider);
    var min = 0;
    var max = $slider.attr('max');
    var scoreValues = $slider.data("scorelevelvals");
    var scoreNames = $slider.data("scorelevelnames");
    if(scoreValues.length && !!$.inArray(min, scoreValues)){
      scoreValues.unshift(+min);
      scoreNames.unshift("Minimum");
    }
    if(scoreValues.length && !!$.inArray(max, scoreValues)){
      scoreValues.push(+max);
      scoreNames.push("Maximum");
    }
    $slider.slider({
      range: "min",
      min: min,
      max: max,
      stop: function(event, ui) {
        console.log(ui.value);
      },
      slide: function(event, ui) {
        if(scoreValues.length) {
          var closest = null;
          $.each(scoreValues, function(){
            if (closest == null || Math.abs(this - ui.value) < Math.abs(closest - ui.value)) {
              closest = this;
            }
          });
          $(this).slider("value", closest);
          $(slider).siblings("div.assignment > span.pScore").html(closest);
          $(slider).siblings("div.assignment > span.score-level-name").html("(Score Level: " + scoreNames[scoreValues.indexOf(+closest)] + ")");
          return false;
        }
        else {
          $(slider).siblings("div.assignment > span.pScore").html(ui.value);
        }
      }
    });
  });

  $('.slider').each(function(i,slider) {
    $slider = $(slider)
    $(slider).siblings("div.assignment > span.pScore").html($slider.attr('value'));
    $slider.slider({
      max: parseInt($slider.attr('max')),
      value: parseInt($slider.attr('value')),
      stop: function(event, ui) {
        assignment_id = $(slider).parent().data("assignment");
        $.ajax({
            url: '/assignments/' + assignment_id + '/grades/predict_score',
            type: "POST",
            data: { predicted_score: ui.value },
            dataType: 'json'
        });
      }
    });
    $slider.on('slide', function(event, ui){
      $(slider).siblings("div.assignment > span.pScore").html(ui.value)
    });
  });


  $('#predictor').on('click', ':checkbox', function() {
    var assignment_id = $(this).parent().data("assignment");
    if(this.checked){
      var value = $(this).val();
    }else{
      var value = 0;
    }
    $.ajax({
      url: '/assignments/' + assignment_id + '/grades/predict_score',
      type: "POST",
      data: { predicted_score: value },
      dataType: 'json'
    });
  })

  $("select.point-value").change(function(){
    var assignment_id = $(this).parent().data("assignment");
    var value = $(this).val().length ? $(this).val() : 0;
    $.ajax({
      url: '/assignments/' + assignment_id + '/grades/predict_score',
      type: "POST",
      data: { predicted_score: value },
      dataType: 'json'
    });
  })

  $('#userBarInProgress').show();
	// $('#userBarTotal').hide();
	$('#userBarInProgressSim').show();
	$('#userBarTotalSim').show();
	$('#totalScoreToggle').show();
  $('#soFarScoreToggle').hide();
  var $totalChart = $('.user-bar-total-chart');
  var $inProgressChart = $('#user-bar-in-progress-chart');

  var $toggleCharts = $('.toggle-charts'), $toggles = $toggleCharts.find('.dashboard-toggle');

  $toggleCharts.on('click', '.dashboard-toggle', function() {
    var $toggle = $(this), selector = $toggle.data('shows');
    $(selector).removeClass('hidden-chart');
    $toggleCharts.children('.chart-wrapper').not(selector).addClass('hidden-chart');
    return false;
  });

  if ($toggleCharts.length) {
    $toggles.show();
    $totalChart.addClass('hidden-chart');
  }

  // Fix input element click problem
  $('.dropdown input, .dropdown label').click(function(e) {
    e.stopPropagation();
  });

  $('#course_id').change(function() { $(this).closest('form').submit(); });

  //$('.nav-tabs').button();

	// handle 'select all' button
	$(".select-all").click(function(e){
		var $link = $(this);

		e.preventDefault();
		$link.parents().find('input[type="checkbox"]').prop('checked', 'checked').trigger('change');
	});

	// handle 'select none' button
	$(".select-none").click(function(e){
	 var $link = $(this);

		e.preventDefault();
		$link.parents().find('input[type="checkbox"]').prop('checked', false).trigger('change');

	});

  var sparkOpts = {
    type: 'box',
    width: '100%',
  };

  if ($('#highchart').length) {

    //get required data for Highchart.
    function formatData (data) {
      var series = []
      for (var i=0; i<data.length; i++) {
        series[i] = []
        //sort scores.
        data[i] = data[i].sort(function (a, b) {return a - b})
        var q_length = data[i].length + 1
        //get lowest value
        series[i].push(Math.min.apply(Math, data[i]))

        //get lower quartile
        series[i].push(data[i][(Math.floor(q_length / 4))])

        //get median
        if (q_length == 2) {
          //if there's only one value...
          series[i].push(data[i][0])
        } else if (q_length % 2 == 0) {
          //if there's an even number of members in the set
          var index = Math.floor(data.length / 2)
          series[i].push((data[i][index] + data[i][index-1]) / 2)
        } else {
          //otherwise standard
          series[i].push(data[i][Math.floor(data.length / 2)])
        }

        //get upper quartile
        series[i].push(data[i][(Math.floor(q_length * 0.75 - 1))])

        //get max value
        series[i].push(Math.max.apply(Math, data[i]))
      }

      return series;
    }

    $.getJSON('/students/scores_by_team', function (data) {
      console.log(data)
      data = data.scores
      var categories = [], scores = {
        name: 'Stats:',
        data: [],
        tooltip: {
        }
      }

      for (var i=0, k=1, index = 0; i <data.length; i++) {
        if (k < data[i][0]) {
          index++
          k = data[i][0]
        }
        if (scores.data[index] == undefined) {
          scores.data[index] = []
          categories.push(data[i][2])
        }
        scores.data[index].push(data[i][1])
      }

      scores.data = formatData(scores.data)

      $('#highchart').highcharts({
        chart: {
          type: 'boxplot'
        },
        title: {
          text: 'Distribution across teams'
        },
        legend: {
          enabled: false
        },
        xAxis: {
          categories: categories,
          title: {
            text: 'Team No.'
          }
        },
        yAxis: {
        },
        series: [ scores ]
      })
    })
  }

  if ($('#grade_distro').length) {
    $.getJSON('/students/scores_for_current_course.json', function (data) {
      sparkOpts.height = '50px';
      $('#grade_distro').sparkline(data.scores, sparkOpts);
    })
  }

  if ($('#student_grade_distro').length) {
    var data = JSON.parse($('#student_grade_distro').attr('data-scores'));
    if (data !== null) {
      sparkOpts.height = '50px';
      sparkOpts.target = data.user_score[0];
      sparkOpts.tooltipOffsetY = -130;
      sparkOpts.tooltipOffsetY = -80;
      sparkOpts.targetColor = "#FF0000";
      $('#student_grade_distro').sparkline(data.scores, sparkOpts);
    }
  }

  if ($('.bar-chart').length) {
    var assignmentTypeScores
    function assignmentTypeBars () {
      if (!assignmentTypeScores) return;
      $('.bar-chart').each(function () {
          var id = this.getAttribute('data-id');
          var scores = assignmentTypeScores[id];
          var names = assignmentTypeScores.names[id];
          var series = []
          for (var i =0; i < scores.length; i++) {
            series.push({
              name: names[i],
              data: [ scores[i] ]
            })
          }
          $(this).highcharts({
            chart: {
              type: 'bar',
              height: '50',
              width: '250'
            },
            title: {
              text: ''
            },
            yAxis: {
              min: 0,
              title: {
                text: ''
              }
            },
            tooltip: {
              positioner: function (boxWidth, boxHeight, point) {
                var chart = this.chart,
                    plotLeft = chart.plotLeft,
                    plotRight = chart.plotRight,
                    plotTop = chart.plotTop,
                    plotWidth = chart.plotWidth,
                    plotHeight = chart.plotHeight,
                    distance = this.options.distance,
                    pointX = point.plotX,
                    pointY = point.plotY,
                    x = pointX + plotLeft + (chart.inverted ? distance : -boxWidth - distance),
                    y = pointY - boxHeight + plotTop + 15,
                    alignedRight;
                if (x , 7) {x = plotLeft + pointX + distance;}

                if ((x + boxWidth) > plotLeft + plotWidth) {
                  x -= (x + boxWidth) - (plotLeft + plotWidth);
                  y = pointY - boxHeight + plotTop - distance;
                  alignedRight = true;
                }
                if (y < plotTop + 5) {
                  y = plotTop + 5;
                  if (alignedRight && pointY >= y && pointY <= (y + boxHeight)) {
                    y = pointY + plotTop + distance;
                  }
                }

                if (y + boxHeight > plotTop + plotHeight) {
                  y = Math.max(plotTop, plotTop + plotHeight - boxHeight - distance);
                }

                return {x: x, y: y};
              }
            },
            credits: {
              enabled: false
            },
            exporting: {
              enabled: false
            },
            legend: {
              enabled: false
            },
            plotOptions: {
              series: {
                stacking: 'normal'
              }
            },
            series: series
          });
      })
    }

    $.getJSON('/students/scores_by_assignment.json', function (data) {
      assignmentTypeScores = {};
      assignmentTypeScores.names = {};
      var studentId;
      data.scores.forEach(function (row) {
        if (studentId != row[0]) {
          studentId = row[0];
          assignmentTypeScores[studentId] = [];
          assignmentTypeScores.names[studentId] = [];
        }
        assignmentTypeScores[studentId].push(row[2]);
        assignmentTypeScores.names[studentId].push(row[1]);
      })
      assignmentTypeBars();
    })

    // Ask Cory.
    $('.table-toggle').on('click', assignmentTypeBars);
  }
});
