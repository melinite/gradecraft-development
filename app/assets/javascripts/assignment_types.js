!function($) {
  var init = function() {
    var $form = $('form');

    $form.on('click', '.add-level', function(e) {
      var $wrapper = $('.score-levels');
      var template = $('#score-level-template').html().replace(/child_index/g, $wrapper.children('.score-level').length);
      $wrapper.append(template);
      return false;
    });

    $form.on('click', '.remove-level', function(e) {
      var $link = $(this);
      $link.prev('input.destroy').val(true);
      $link.closest('fieldset.score-level').hide();
      return false;
    });

    $form.on('click', '.add-assignment-score-level', function(e) {
      var $wrapper = $('.assignment-score-levels');
      var template = $('#assignment-score-level-template').html().replace(/child_index/g, $wrapper.children('.assignment-score-level').length);
      $wrapper.append(template);
      return false;
    });

    $form.on('click', '.remove-assignment-score-level', function(e) {
      var $link = $(this);
      $link.prev('input.destroy').val(true);
      $link.closest('fieldset.assignment-score-level').hide();
      return false;
    })
  };
  $(init);
}(jQuery);