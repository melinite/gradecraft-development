// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery.fileupload
//= require jquery-ui
//= require jquery_ujs
//= require jquery.dynatable
//= require jquery.omniselect
//= require backbone.min
//= require best_in_place
//= require best_in_place.purr
//= require bootstrap
//= require flexslider
//= require gradecraft
//= require grade_schemes
//= require preload_store
//= require_self
//= require assignment_types
//= require assignments
//= require grade_schemes
//= require nested_fields
//= require users
//= require user_dashboard
//= require selectToUISlider.jQuery
//= require submissions
//= require submission_file
//= require underscore.min
//= require timelineJS/embed
//= require timeline
//= require stupidtable

$(document).ready(function(){

  $('#gradeCurious').popover();

  $('collapse').collapse('toggle');

  $('#toDoList').collapse('hide');

  $('#myModal').modal('hide');

  $("#simpleTable").stupidtable();

  $('#easyTab a').click(function (e) {
    e.preventDefault();
    $('#easyTab a[href="#basic"]').tab('show'); // Select tab by name
    $('#easyTab a:first').tab('show'); // Select first tab
    $('#easyTab a:last').tab('show'); // Select last tab
    $('#easyTab li:eq(2) a').tab('show'); // Select third tab (0-indexed)

  });

  $('.datetimepicker').datetimepicker({
    format: 'yyyy-mm-dd hh:ii'
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

  // Fix input element click problem
  $('.dropdown input, .dropdown label').click(function(e) {
    e.stopPropagation();
  });

	$('#userBarTotalSim').show();

$('#course_id').change(function() { $(this).closest('form').submit(); });

$('.nav-tabs').button();

	// handle 'select all' button
	$(".select-all").click(function(e){
		var $link = $(this);

		e.preventDefault();
		$link.parents().find("input").prop("checked", "checked");
	});

	// handle 'select none' button
	$(".select-none").click(function(e){
	 var $link = $(this);

		e.preventDefault();
		$link.parents().find("input").prop("checked", false);

	});
});
