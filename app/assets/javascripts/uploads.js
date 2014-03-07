// File Uploads

  if ($('.s3_uploader').length) {
    $('.s3_uploader').S3Uploader({
      allow_multiple_files: true,
      remove_completed_progress_bar: false,
      remove_failed_progress_bar: false,
      progress_bar_target: $('.s3_progress')
    })

    // formatSubmissionField :: jQuery input object -> form length -> correct field
    function formatSubmissionField (field, n) {
      var newName, newId
      newName = field.attr('name').replace('0', n)
      newId = field.attr('id').replace('0', n)
      field.attr('id', newId)
      field.attr('name', newName)
      return field
    }
    $('.s3_uploader').bind('s3_upload_complete', function (e, content) {
      if ($('.s3_files').val()) {
        var field = $('.s3_files').first().clone()
        field = formatSubmissionField(field, $('.s3_files').length)
        $('.s3_files').parent().append(field)
        $('.s3_files').last().val(content.filepath)
      } else {
        $('.s3_files').val(content.filepath)
      }
      $('#uploaded_files').append('<li> ' + content.filename + '</li>')

      $('.s3_progress').css('visibility', 'hidden')
    })

    $('.s3_uploader').bind('s3_upload_failed', function (e, content) {
      alert(content.filename +' failed to upload: ' + content.error_thrown)
      $('.s3_progress').css('visibility', 'hidden')
    })

    $('.s3_uploader').bind('s3_uploads_start', function (e) {
      $('.s3_progress').css('visibility', 'visible')
    })
  }

  $('s3_uploader').bind('s3_upload_failed', function (e, content) {
    alert(content.filename +' failed to upload: ' + content.error_thrown)
  })