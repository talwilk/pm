$(function() {
  $('#change_avatar').click(function (e) {
    $('#update_user_profile_form_avatar').click();
  })

  $('#avatar-replace').click(function (e) {
   $('#update_user_profile_form_avatar').click();
  })
})

function previewImg(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('#img_upload, .current-avatar')
        .attr('src', e.target.result)
    };

    reader.readAsDataURL(input.files[0]);
  }
}
