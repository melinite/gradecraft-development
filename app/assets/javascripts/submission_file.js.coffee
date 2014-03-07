$ ->
  $('#submission').fileupload
    done: (e, data)->
      console.log "Done", data.result
      $('<li>' + data.result + '</li>').appendTo(this)