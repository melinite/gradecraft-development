$(document).ready(function() {
  $('form.mass-edit-earned-badges').on('change', 'input[type="checkbox"]', function() {
    $input = $(this);
    $destroy = $input.parent().children('input.destroy');
    $destroy.val(!$input.is(':checked'));
  });
});
