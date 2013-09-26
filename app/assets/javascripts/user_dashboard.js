$(document).ready(function() {
  $('.share_badge').on('click', function () {
    var badge_id = this.getAttribute('data-badge-id'),
        earned_id = this.getAttribute('data-earned-badge-id')
    $.ajax({
      url: '/badges/' + badge_id + '/earned_badges/' + earned_id + '/toggle_shared',
      method: 'post',
      data: {
        earned_badge_id: earned_id
      },
      success: function (data) {
        if (data.shared) {
          $('#shared_' + badge_id).text("Stop Sharing")
        } else {
          $('#shared_' + badge_id).text("Share")
        }
        $('#shared_' + badge_id).toggleClass('btn-success', !data.shared)
        $('#shared_' + badge_id).toggleClass('btn-warning', data.shared)
      }
    })
  })

	var options = {
    chart: {
      type: 'bar',
      backgroundColor:null,
    },
    title: {
      style: {
        color: "#FFFFFF"
      }
    },
    credits: {
      enabled: false
    },
    xAxis: {
      title: {
        text: ' '
      },
      labels: {
        style: {
          color: "#222"
        }
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'Available Points'
      }
    },
    labels: {
      plotLines: [{
        color: '#808080'
      }]
    },
    tooltip: {
      formatter: function() {
        return '<b>'+ this.series.name +'</b><br/>'+
        this.y +' points';
      }
    },
    plotOptions: {
      series: {
        stacking: 'normal',
        events: {
          legendItemClick: function(event){
            return false;
          }
        }
      }
    },
    legend: {
      backgroundColor: null,
      borderColor:null,
      reversed: true,
      itemStyle: {
        color: '#CCCCCC'
      }
    },
  };

    var chart, categories, assignment_type_name, scores;
    if ($('#userBarInProgress').length) {
      var data = JSON.parse($('#data-predictor').attr('data-predictor'));

      // Get Assignment Type Info
      options.chart.renderTo = 'userBarInProgress';
      options.title = { text: 'My Points' };
      options.xAxis.categories = { text: ' ' };
      options.yAxis.max = data.course_total;
      options.series = data.scores;
      chart = new Highcharts.Chart(options);

      options.chart.renderTo = 'userBarTotal';
      options.title = { text: 'Total Possible Points' };
      options.xAxis.categories = { text: ' ' };
      options.yAxis.max = data.in_progress;
      options.series = data.scores;
      chart = new Highcharts.Chart(options);
    };

    var options = {
    chart: {
      type: 'bar',
      backgroundColor:null,
    },
    title: {
      style: {
        color: "#FFFFFF"
      }
    },
    credits: {
      enabled: false
    },
    xAxis: {
      title: {
        text: ' '
      },
      labels: {
        style: {
          color: "#222"
        }
      }
    },
    yAxis: {
      min: 0,
      title: {
        text: 'Available Points'
      }
    },
    labels: {
      plotLines: [{
        color: '#808080'
      }]
    },
    tooltip: {
      formatter: function() {
        return '<b>'+ this.series.name +'</b><br/>'+
        this.y +' points';
      }
    },
    plotOptions: {
      series: {
        stacking: 'normal',
        events: {
          legendItemClick: function(event){
            return false;
          }
        }
      }
    },
    legend: {
      backgroundColor: null,
      borderColor:null,
      reversed: true,
      itemStyle: {
        color: '#CCCCCC'
      }
    },
  };

    var chart, categories, assignment_type_name, scores;

    var $wrapper = $('#userBarInProgressSim');
    if($wrapper.length) {
      var studentID = $('#studentID').data('user-id');
      /*

      // Get Assignment Type Info
      $.getJSON('/users/predictor.json?in_progress=true', { user_id: userID }, function(data) {
        options.chart.renderTo = 'userBarInProgressSim';
        options.title = { text: 'Points so far' };
        options.xAxis.categories = { text: ' ' };
        options.yAxis.max = data.course_total
        options.series = data.scores
        chart = new Highcharts.Chart(options);
      });
*/

      $.getJSON('/users/predictor.json', { student_id: studentID }, function(data) {
        options.chart.renderTo = 'userBarTotalSim';
        options.title = { text: 'Total Points' };
        options.xAxis.categories = { text: ' ' };
        options.yAxis.max = data.course_total
        options.series = data.scores
        chart = new Highcharts.Chart(options);
      });

    };
});
