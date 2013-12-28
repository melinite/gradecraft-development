// add commas to predictor displays below
function addCommas(i){
	numWithCommas = i.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	return numWithCommas;
};

function isStaff(){
  return !!$(".staff").length
}

var chartOptions = {
  chart: {
    renderTo: 'prediction',
    type: 'bar',
    backgroundColor:null
  },
  title: {
    text: ' ',
    style: {
      color: "#FFFFFF"
    }
  },
  subtitle: {
    text: ''
  },
  credits: {
    enabled: false
  },
  xAxis: {
    labels: {
      style: {
        color: "#FFFFFF"
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
    formatter: function(){
      return this.value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    },
    plotLines: [{
      value: 0,
      width: 1,
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
      stacking: 'normal'
    }
  },
  legend: {
    backgroundColor: null,
    borderColor:null,
    reversed: true,
    itemStyle: {
      color: '#333333'
    }
  },
  series: []
};

var AssignmentType = Backbone.Model.extend();

var AssignmentTypesArray = Backbone.Collection.extend({
  model: AssignmentType
});

var PredictorView = Backbone.View.extend({
  el: '#predictorPage',
  initialize: function() {
    this.collection = new AssignmentTypesArray();
    this.createAssignmentTypes();
    this.calculateScores();
    this.setupChart();
    this.collection.bind('change',this.render,this);
    this.$el = $(this.el);
    this.render();
  },
  render: function() {
    var chart = this.model;
    chart.yAxis[0].setExtremes(0,this.calculateCourseTotal());
    var scoreTotal = 0;
    this.collection.forEach(function(assignmentType,i) {
      chart.series[i].setData([assignmentType.get('score')])
      scoreTotal += assignmentType.get('score');
    });
    $('#predictor-score-display').html(addCommas(scoreTotal));
    var gradeLevels = $('#predictor-course-grade').data('grade-levels');
    var currentGradeLevel, grade, level;
    if(gradeLevels != null && gradeLevels.length){
      current_grade_level = _.max(gradeLevels, function(gradeLevel){ return gradeLevel[0] <= scoreTotal })
      grade = current_grade_level[1];
      level = current_grade_level[2];
    }
    if(level){
      $('#predictor-course-grade').html(grade + " ("+level+")");
    }else{
      $('#predictor-course-grade').html(grade);
    }
    $('#predictor-course-total-display').html(addCommas(this.calculateCourseTotal()));

  },
  createAssignmentTypes: function() {
    var assignmentTypes = this.collection;
    $.each(this.$el.find('.slides li').not('.clone'),function(i,slide) {
      $slide = $(slide);
      if ($slide.attr('id') == 'slide-required') {
        return true; // Required slide just duplicates assignments from other slides, so we can ignore it
      }
      var assignmentTypeName = $slide.data('assignment-type-name');
      var assignmentTypeId = $slide.data('assignment-type-id');
      assignmentTypes.add(new AssignmentType({ id: assignmentTypeId, name: assignmentTypeName, score: 0 }));
    });
  },
  setupChart: function() {
    this.collection.forEach(function(assignmentType,i) {
      chartOptions.series.push({ name: assignmentType.get('name'), data: [assignmentType.get('score')] });
    });
    chartOptions.xAxis.categories = ' ';
    chartOptions.yAxis.max = this.calculateCourseTotal();
    this.model = new Highcharts.Chart(chartOptions);
  },
  events: {
    'change input': 'calculateScores',
    'change select': 'calculateScores',
    'slidestop .slider': 'calculateScores'
  },
  calculateCourseTotal: function() {
    var courseTotal = 0;
    var $slide = this.$el.find('li#slide-badges')
    $.each($slide.find('input'), function(i,item) {
      var $item = $(item);
      if ($item.is(':checked')) {
        courseTotal += parseInt($item.val());
      }
    });
    courseTotal += parseInt(this.$el.data('course-total'));
    return courseTotal;
  },
  calculateScores: function(e) {
    var assignmentTypes = this.collection;
    $.each(this.$el.find('.slides li').not('.clone'),function(i,slide) {
      var $slide = $(slide);
      if ($slide.attr('id') == 'slide-required') {
        return true;
      }
      var assignmentTypeId = $slide.data('assignment-type-id');
      var score = 0;
      $.each($slide.find('input, select, .slider'), function(i,item) {
        var $item = $(item),
            itemScore = getScore($item);
        score += itemScore;
      });
      assignmentTypes.get(assignmentTypeId).set('score',score);
    });
    if (e) {
      var $item = $(e.target),
          $assignment = $item.closest('.assignment'),
          assignmentId = $assignment.data('assignment'),
          score = getScore($item),
          possibleScore = $assignment.data('possible-points');
      $.ajax('/analytics_events/predictor_event', {
        method: 'post',
        data: {
          assignment: assignmentId,
          score: score,
          possible: possibleScore
        }
      });
    }
  }
});

var getScore = function($item) {
  if($item.is(':checkbox') && $item.is(':checked')) {
    return parseInt($item.val());
  } else if ($item.is('select')) {
    return parseInt($item.children('option:selected').val() || 0);
  } else if ($item.is('input[type="hidden"]')) {
    return parseInt($item.val());
  } else if ($item.is('.slider') || $item.is(".ui-slider")) {
    if($item.is(".ui-slider")){
      return parseInt($item.slider('value'));
    }else{
      return parseInt($item.attr("value"));
    }
  } else {
    return 0;
  }
}

$(document).ready(function() {
  var $wrapper = $('#prediction');
  if ($wrapper.length) {
    new PredictorView();
  }

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
        if(!isStaff()){
          $.ajax({
              url: '/assignments/' + assignment_id + '/grades/predict_score',
              type: "POST",
              data: { predicted_score: ui.value },
              dataType: 'json'
          });
        }
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
    if(!is_staff()){
      $.ajax({
        url: '/assignments/' + assignment_id + '/grades/predict_score',
        type: "POST",
        data: { predicted_score: value },
        dataType: 'json'
      });
    }
  })

  $("select.point-value").change(function(){
    var assignment_id = $(this).parent().data("assignment");
    var value = $(this).val().length ? $(this).val() : 0;
    if(!isStaff()){
      $.ajax({
        url: '/assignments/' + assignment_id + '/grades/predict_score',
        type: "POST",
        data: { predicted_score: value },
        dataType: 'json'
      });
    }
  })
});