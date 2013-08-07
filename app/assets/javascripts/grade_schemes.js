!function($) {
  var init = function() {
    var $form = $('form');

    $form.on('click', '.add-element', function(e) {
      var $wrapper = $('.grade-scheme-elements');
      var template = $('#grade-scheme-element-template').html().replace(/child_index/g, $wrapper.children('.grade-scheme-element').length);
      $wrapper.append(template);
      return false;
    });

    $form.on('click', '.remove-element', function(e) {
      var $link = $(this);
      $link.prev('input.destroy').val(true);
      $link.closest('fieldset.grade-scheme-element').hide();
      return false;
    })
  };
  $(init);
}(jQuery);
