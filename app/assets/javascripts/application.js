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
//= require jquery.sparkline.min
//= require underscore.min
//= require backbone.min
//= require best_in_place
//= require best_in_place.purr
//= require bootstrap
//= require gradecraft
//= require preload_store
//= require selectToUISlider.jQuery
//= require_self
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

$(document).ready(function(){

  $('#gradeCurious').popover();

  $('.collapse').collapse('toggle');

  $('#toDoList').collapse('hide');

  $('#courseInfo').collapse('hide');

  $('#badgesInfo').collapse('hide');

  $('#academicInfo').collapse('hide');

  $('#myModal').modal('hide');

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

  $('#easyTab a').click(function (e) {
    e.preventDefault();
    $('#easyTab a[href="#basic"]').tab('show'); // Select tab by name
    $('#easyTab a:first').tab('show'); // Select first tab
    $('#easyTab a:last').tab('show'); // Select last tab
    $('#easyTab li:eq(2) a').tab('show'); // Select third tab (0-indexed)
  });

  /* Activating Best In Place */
  jQuery(".best_in_place").best_in_place();

  $("a[rel=popover]").popover();
  $('.tooltip, a[rel="tooltip"]').tooltip();

	$('#navbar').affix();

  $('.slider').each(function(i,slider) {
    $slider = $(slider)
    $slider.slider({
      max: $slider.attr('max')
    });
    $slider.on('slide', function(event, ui){
      $(slider).prev("div.assignment > span").html(ui.value)
    });
  });


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

  $('.nav-tabs').button();

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

  if ($('#grade_distro').length) {
    $.getJSON('/users/scores_for_current_course.json', function (data) {
      $('#grade_distro').sparkline(data.scores, { type: 'box', width: '100%', height: '50px' } )
    })
  }

  if ($('#student_grade_distro').length) {
    $.getJSON('/users/scores_for_current_course.json', function (data) {
      $('#student_grade_distro').sparkline(data.scores, { type: 'box', width: '100%', height: '40px' } )
    })
  }

  if ($('.bar-chart').length) {
    var assignmentTypeScores
    function assignmentTypeBars () {
      if (!assignmentTypeScores) return;
      $('.bar-chart').each(function () {
          var id = this.getAttribute('data-id');
          var scores = assignmentTypeScores[id];
          var series = []
          for (var i =0; i < scores.length; i++) {
            series.push({
              name: '',
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

    $.getJSON('/users/scores_by_assignment.json', function (data) {
      assignmentTypeScores = {};
      var studentId;
      data.scores.forEach(function (row) {
        if (studentId != row[0]) {
          studentId = row[0];
          assignmentTypeScores[studentId] = [];
        }
        assignmentTypeScores[studentId].push(row[2]);
      })
      assignmentTypeBars();
    })
  }

  // Ask Cory.
  $('.table-toggle').on('click', assignmentTypeBars);
});
