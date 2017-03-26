function appendListener(formClass) {
  if ($(formClass).length === 0) {
    return;
  }

  $(formClass).areYouSure();

  $(window).on('beforeunload', function() {
    if ($(".nested-fields")[0] && $(formClass)[0]) {
      return 'You have unsaved changes!';
    }
  });

  $(document).on("submit", "form", function(event) {
    $(window).off('beforeunload');
  });
}

$(function() {
  appendListener(".simple_form.new_dilemma");
  appendListener(".simple_form.edit_dilemma");
});
