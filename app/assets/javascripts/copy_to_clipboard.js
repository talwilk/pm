$(document).ready(function(){
  $('#copy-dilemma-link').on('click', function copy(e) {
    var input = $($(this).data('copytarget'));

    if (input && input.select) {
      input.select();

      try {
        document.execCommand('copy');
        input.blur();
      }
      catch (err) {
        alert('please press Ctrl/Cmd+C to copy');
      }
    }
  });
});
