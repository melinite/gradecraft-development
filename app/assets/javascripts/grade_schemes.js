!function($) {
  var init = function() {
    var $form = $('form');

    $form.on('click', '.add-element', function(e) {
      var $elements = $('.grade-scheme-element');
      var template = $('#grade-scheme-element-template').html().replace(/child_index/g, $elements.length);
      $elements.last().after(template);
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
