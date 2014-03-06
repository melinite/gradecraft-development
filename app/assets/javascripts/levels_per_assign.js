$(document).ready(function() {
 var options = {
      chart: {
        plotBackgroundColor: null,
        plotBorderWidth: null,
        plotShadow: false,
        renderTo: 'levels_per_assignment'
        },
      title: {
        text: 'Percentage of Earned Scores'
      },
      tooltip: {
        pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
      },
      credits: {
        enabled: false
      },
      plotOptions: {
        pie: {
          allowPointSelect: false,
          cursor: 'pointer',
          dataLabels: {
            enabled: true,
            color: '#000000',
            connectorColor: '#000000'
          }
        }
      },
      series: []
    };

    var seriesNew = {
      type: 'pie',
      data: []
    };

    if ($('#levels_per_assignment').length) {
      data = JSON.parse($('#levels_per_assignment').attr('data-levels'));
      myJson = data.scores;
    
      jQuery.each(myJson, function (itemNo, item) {
        seriesNew.data.push({
          name: String(item.name),
          y: item.data
        })
      });

      options.series.push(seriesNew); 

      chart = new Highcharts.Chart(options);
    }

});