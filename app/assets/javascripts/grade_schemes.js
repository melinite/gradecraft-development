!function($) {
  var $document = $(document);

  var init = function() {
    $document.on('click', '.add-element', addElement);
    $document.on('click', '.remove-element', removeElement);
  }

  var addElement = function() {
    console.log('Add');
    var $elements = $('fieldset.element');
    var template = $('#element-template').html().replace(/child_index/g, $elements.length);
    $('fieldset.elements').append(template);
    return false;
  };

  var removeElement = function() {
    var $link = $(this);
    $link.prev('input.destroy').val(true);
    $link.closest('fieldset.element').hide();
    return false;
  };

  init();
}(jQuery);
