// Matching the main content div to the size of the window
//Initial load of page
$(document).ready(sizeContent);

//Every resize of window
$(window).resize(sizeContent);

//Dynamically assign height
function sizeContent() {
    var newHeight = $(document).height() + "px";
    $(".mainContent").css("height", newHeight);
}

// handle 'select all' buttons, used on release grade forms
$(".select-all").click(function(e){
  var $link = $(this);

  e.preventDefault();
  $link.parents().find('input[type="checkbox"]').prop('checked', 'checked').trigger('change');
});

// handle 'select none' button, used on release grade forms
$(".select-none").click(function(e){
 var $link = $(this);

  e.preventDefault();
  $link.parents().find('input[type="checkbox"]').prop('checked', false).trigger('change');

});

// Initializing collapse plugin
// with custom show/hide methods,
// persistence plugin and accordion behaviour
$(".assignment_type").collapse({
  show: function() {
    // The context of 'this' is applied to
    // the collapsed details in a jQuery wrapper 
    this.slideDown(100);
  },
  hide: function() {
    this.slideUp(100);
  },
  accordion: true,
  persist: true
});

// Select2 Search forms for group creation
$("#group_student_ids").select2({
  placeholder: "Select Students",
  allowClear: true
});

// Select2 Search forms for team creation
$("#team_student_ids").select2({
  placeholder: "Select Students",
  allowClear: true
});

// Initializing highcharts table data, currently used to display team charts
$('table.highchart').highchartTable();
