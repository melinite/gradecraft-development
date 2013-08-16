$ ->
  $('#submission').fileupload
    done: (e, data)->
      console.log "Done", data.result
      $(data.result).appendTo(this)