!function($) {
  var init = function() {
    console.log('clicked');
    var $form = $('form');

    $form.on('click', '.add-file', function(e) {
      console.log('clicked');
      var $wrapper = $('.submission-files');
      var template = $('#submission-file-template').html().replace(/child_index/g, $wrapper.children('.submission-file').length);
      $wrapper.append(template);
      return false;
    });

    $form.on('click', '.remove-file', function(e) {
      var $link = $(this);
      $link.prev('input.destroy').val(true);
      $link.closest('fieldset.submission-file').hide();
      return false;
    })
  };
  $(init);
}(jQuery);