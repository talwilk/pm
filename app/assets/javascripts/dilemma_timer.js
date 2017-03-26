function initializeTimers(){
  $('.dilemma-item__timer div').each(function(){
    var end = $(this).attr("data-server");
    var lang = $(this).attr("translation");
    var days = $(this).attr("days");
    var hours = $(this).attr("hours");
    var minutes = $(this).attr("minutes");
    var remaining = $(this).attr("remaining");
    $(this).countdown(end, {elapse: true})
    .on('update.countdown', function(event) {
      var $this = $(this);
      if (event.elapsed) {
        $(this).html(lang);
          $('.dilemma-item__advice-form').hide();
          $('#remove_dilemma_link').remove();
          $('#edit_dilemma_link').remove();
      }
      else {
        $(this).html(event.strftime("%-d " + days + " %H " + hours + " %M "+ minutes + " " + "<span>" + remaining + "</span>"));
      }
    });
  });
}

$(document).ready(function(){
  initializeTimers();
});
