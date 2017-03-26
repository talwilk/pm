function buildModalCallback(modalId) {
  return function() {
    var modal = UIkit.modal(modalId, { center: true });

    if (modal.isActive()) {
      modal.hide();
    } else {
      modal.show();
    }
  }
}

function set_medias_inputs() {
  $(".append-youtube-url").click(buildModalCallback("#youtubeModal"));
  $(".append-image-url").click(buildModalCallback("#imageModal"));
  $(".append-image-file").click(buildModalCallback("#fileModal"));

  $('.add-image-file').click(function () {
    $('.append-image-file').click();
  });

  $('.add-image-url').click(function () {
    $('.append-image-url').click();
  });

  $('.add-youtube-url').click(function () {
    $('.append-youtube-url').click();
  });

  $("#youtube_url_insert_button").click(function () {
    var input = $('#youtube_url_modal_input').val();

    if (input.length === 0) {
      $(".nested-fields:not(.filled) > .remove_fields").click();
    } else {
      var youtubeID = YouTubeGetID(input);

      $('.nested-fields:not(.filled) #youtube_upload')
        .attr('src', 'http://img.youtube.com/vi/' + youtubeID + '/0.jpg');
      $(".nested-fields:not(.filled) input").val(input);
      $(".nested-fields:not(.filled)").addClass('filled').prependTo(".medias").show();
      UIkit.modal("#youtubeModal").hide();
      $('#youtube_url_modal_input').val('');
    }
  });

  $("#youtube_url_cancel_button").click(function () {
    $(".nested-fields:not(.filled) > .remove_fields").click();
  });

  $("#image_url_insert_button").click(function () {
    var input = $('#image_url_modal_input').val();

    if (input.length === 0) {
      $(".nested-fields:not(.filled) > .remove_fields").click();
    } else {
      $('.nested-fields:not(.filled) #img_url_upload')
        .attr('src', input);
      $(".nested-fields:not(.filled) input").val(input);
      $(".nested-fields:not(.filled)").addClass('filled').prependTo(".medias").show();
      UIkit.modal("#imageModal").hide();
      $('#image_url_modal_input').val('');
    }
  });

  $("#image_url_cancel_button").click(function () {
    $(".nested-fields:not(.filled) > .remove_fields").click();
  });

  $("#file_upload_insert_button").click(function () {
    $(".nested-fields:last-child input:file").click();
  });

  $("#file_upload_cancel_button").click(function () {
    $(".nested-fields:not(.filled) > .remove_fields").click();
  });

  $("#file_upload_submit_button").click(function () {
    var input = $(".nested-fields:not(.filled) input:file").val();

    if (input.length === 0) {
      $(".nested-fields:not(.filled) > .remove_fields").click();
    } else {
      $(".nested-fields:not(.filled) > #browse").val(input);
      $(".nested-fields:not(.filled)").addClass('filled').prependTo(".medias").show();
    }
  });
}

$(function() {
  set_medias_inputs();

  // Prevent empty nested fields
  $('#fileModal, #imageModal, #youtubeModal').on({
    'hide.uk.modal': function() {
      var nested = $('.nested-fields:not(.filled)');
      if (nested.length) {
        nested.remove();
      }
    }
  });
});

function previewFileImg(input) {
  if (input.files && input.files[0]) {
    var reader = new FileReader();

    reader.onload = function (e) {
      $('.nested-fields:not(.filled) img').attr('src', e.target.result);
      $("#file_upload_submit_button").click();
      UIkit.modal("#fileModal").hide();
    };

    reader.readAsDataURL(input.files[0]);
  }
}

function YouTubeGetID(url){
  var ID = '';

  url = url.replace(/(>|<)/gi,'').split(/(vi\/|v=|\/v\/|youtu\.be\/|\/embed\/)/);

  if (url[2] !== undefined) {
    ID = url[2].split(/[^0-9a-z_\-]/i);
    ID = ID[0];
  } else {
    ID = url;
  }

  return ID;
}
