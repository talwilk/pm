$(function() {
  'use strict';
  var maxlength = $('input[maxLength], textarea[maxLength]');

  maxlength.each(function() {
    var direction = $('.direction').text()
    var element = $(this),
      maxchar = element.attr('maxLength'),
      feedback = $(document.createElement('span')).addClass('maxlength-feedback control-label ' + direction + ' alignment-counter');
    feedback.insertBefore(element);

    element.keyup(function() {
      var text_length = element.val().length;
      var char_remaining = maxchar - text_length;
      feedback.html(char_remaining  + '/' + maxchar);
      if (char_remaining == 0 ) {
        feedback.addClass('remaining-char-0');
      }
      else {
        feedback.removeClass('remaining-char-0');
      }
    });
  });
});
