// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require bootsy
//= require foundation
//= require jquery.omniselect
//= require jquery.sparkline.min
//= require jquery.fileupload
//= require s3_direct_upload
//= require jquery.ui.widget
//= require jquery.sparkline.min
//= require underscore.min
//= require backbone.min
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
//= require grade_scheme_elements
//= require nested_fields
//= require users
//= require student_dashboard
//= require stupidtable
//= require submissions
//= require submission_file
//= require timelineJS/embed
//= require timeline
//= require earned_badges
//= require per-assign
//= require predictor
//= require datetimepicker
//= require highcharts
//= require select2
//= require responsive-tables

$(function(){ $(document).foundation(); });

$(document).ready(function(){

  $("#group_student_ids").select2({
    placeholder: "Select Students",
    allowClear: true
  });

  $("#team_student_ids").select2({
    placeholder: "Select Students",
    allowClear: true
  });

  if ($('.s3_uploader').length) {
    $('.s3_uploader').S3Uploader({
      allow_multiple_files: false,
      remove_completed_progress_bar: false,
      remove_failed_progress_bar: false,
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

      $('.s3_progress').css('visibility', 'hidden')
    })

    $('.s3_uploader').bind('s3_upload_failed', function (e, content) {
      alert(content.filename +' failed to upload: ' + content.error_thrown)
      $('.s3_progress').css('visibility', 'hidden')
    })

    $('.s3_uploader').bind('s3_uploads_start', function (e) {
      $('.s3_progress').css('visibility', 'visible')
    })
  }

  $('s3_uploader').bind('s3_upload_failed', function (e, content) {
    alert(content.filename +' failed to upload: ' + content.error_thrown)
  })

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

  $('#course_id').change(function() { $(this).closest('form').submit(); });

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

  if ($('#shared_badges_table').length) {
    if (!$('#current_user_badges').length) {
      $('#shared_badges_table').append('<tr><td>My badges<td id="current_user_badges"></td></tr>')
    } else {
     $('#current_user_badges').children().each( function (index, child) {
        $(child).attr('data-cid', index + 100)
        $($('.remove_badge')[index]).attr('data-cid', index + 100)
      })
    }


    var Badge = Backbone.Model.extend({
    })

    var BadgeList = Backbone.Collection.extend({
      model: Badge,
      remove_by_value: function (key, val) {
        if ( key === undefined || val === undefined) {
          return
        }
        this.forEach(function (model) {
          if (model.get(key) === val) {
            this.remove(model)
          }
        }, this)
      }
    })

    var AllBadgesView = Backbone.View.extend({
      el: $('.share_badge'),

      events: {
        'click .add_badge': 'add_badge',
        'click .remove_badge': 'remove_badge'
      },

      initialize: function () {
        this.shared_badges = window.shared_badges;
      },

      add_badge: function (e) {
        this.shared_badges.add_badge(e)
      },

      remove_badge: function (e) {
        this.shared_badges.remove_badge(e)
      }
    })

    var SharedBadgeView = Backbone.View.extend({
      el: $('#current_user_badges'),

      initialize: function () {
        this.collection = new BadgeList()
        this.collection.bind('add', this.append_badge)
        this.render()
      },

      render: function () {
      },

      add_badge: function (e) {
        var badge = new Badge()
        $(e.target).data('cid', badge.cid)
        var elem = $(e.target).parent()
        badge.set({
          name: elem.data('name'),
          url: elem.data('icon')
        })
        this.collection.add(badge)
      },

      append_badge: function (badge) {
        $('#current_user_badges').append('<img alt="' + badge.get('name') + '"src="' + badge.get('url') + '" width="40" data-cid="' + badge.cid + '"/>')
      },

      remove_badge: function (e) {
        this.collection.remove_by_value('name', $(e.target).parent().data('name'))
        $('#current_user_badges [data-cid="' + $(e.target).data('cid') + '"]').remove()
      }
    })

    window.shared_badges = new SharedBadgeView()
    window.all_badges = new AllBadgesView()
  }
});