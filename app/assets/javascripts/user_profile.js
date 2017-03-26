function get_end_date() {
  $( ".getting-started-user-profile" ).each(function() {
    var id =$(this).data("dilemma_id");
    var lang = $(this).attr("translation");
    var days = $(this).attr("days");
    var remaining = $(this).attr("remaining");
    var end = $("#getting-started-user-profile-" + id).attr("data-server");
    $("#getting-started-user-profile-" + id).countdown(end, {elapse: true})
      .on('update.countdown', function (event) {
        var $this = $(this);
        if (event.elapsed) {
          $(this).html(lang);
        }
        else {
          $(this).html(event.strftime("%-d " + days + " %Hh %Mm " + "<span>" + remaining + "</span>"));
        }
      });
  });
}
$(function(){
  get_end_date();
});
