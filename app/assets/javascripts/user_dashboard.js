$(document).ready(function() {

	var options = {
    chart: {
      type: 'bar',
      height:150,
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

    var $wrapper = $('#userBarInProgress');
    if($wrapper.length) {
      var userID = $('#userID').data('user-id');

      // Get Assignment Type Info
      $.getJSON('/users/predictor.json?in_progress=true', { user_id: userID }, function(data) {
        options.chart.renderTo = 'userBarInProgress';
        options.title = { text: 'My Points' };
        options.chart.width = '750',
        options.chart.height = '150',
        options.xAxis.categories = { text: ' ' };
        options.yAxis.max = data.course_total
        options.series = data.scores
        chart = new Highcharts.Chart(options);
      });

      $.getJSON('/users/predictor.json', { user_id: userID }, function(data) {
        options.chart.renderTo = 'userBarTotal';
        options.title = { text: 'Total Possible Points' };
        options.chart.height = '150',
        options.chart.width = '750',
        options.xAxis.categories = { text: ' ' };
        options.yAxis.max = data.course_total
        options.series = data.scores
        chart = new Highcharts.Chart(options);
      });

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
      var userID = $('#userID').data('user-id');
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

      $.getJSON('/users/predictor.json', { user_id: userID }, function(data) {
        options.chart.renderTo = 'userBarTotalSim';
        options.title = { text: 'Total Points' };
        options.xAxis.categories = { text: ' ' };
        options.yAxis.max = data.course_total
        options.series = data.scores
        chart = new Highcharts.Chart(options);
      });

    };

  if ($('#grade_distro').length) {
    $.getJSON('/users/scores.json', function (data) {
      var scores = []
      for (var i=0; i < data.scores.length; i++) {
        scores.push(data.scores[i][1])
      }
      $('#grade_distro').sparkline(scores, { type: 'box', width: '100%', height: '30px' } )
    })
  }

});
