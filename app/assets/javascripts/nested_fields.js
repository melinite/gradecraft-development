!function($) {
  var $fields, $items, $link, selector;

  var init = function() {
    $fields = $('.nested-fields'), $items = $fields.children('.list-group');
    $fields.on('click', '.add-item', addItem);
    $fields.on('click', '.remove-item', removeItem);
  };

  var addItem = function() {
    $link = $(this), selector = $link.data('template'),
      template = $(selector).html().replace(/child_index/g, $items.children.length);
    $items.append(template)
    return false;
  };

  var removeItem = function() {
    $link = $(this);
    $link.prev('input.destroy').val(true);
    $link.closest('.list-group-item').hide();
    return false;
  };

  $(init);
}(jQuery);
