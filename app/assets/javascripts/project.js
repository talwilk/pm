$(document).ready(function() {

  $(".task_row").click(function() {
      $(this).next("tr.task_details").slideToggle("fast");
  });

  $(".show_task_details").click(function() {
    $(this).parent('tr').next("tr.task_details").slideToggle("fast");
  });

  $('.cost_paid_btn').click(function(){
    $('#cost').val($(this).data("cost"))
    $('#paid').val($(this).data("paid"))
    $('#cost_paid_submit').attr("task-id", $(this).data("task-id"))
  });

  $('.cost_paid_btn').magnificPopup({
    type: 'inline',
    preloader: false,
    focus: '#cost',
    callbacks: {
      beforeOpen: function(elem) {
        if($(window).width() < 700) {
          this.st.focus = false;
        } else {
          this.st.focus = '#cost';
        }
      }
    }
  });

  $('#cost_paid_submit').click(function(){
    task_id = $(this).attr("task-id")
    $.ajax({
      type: "POST",
      url: '/update_cost_paid/'+task_id,
      data: {
        cost: $('#cost').val(),
        paid: $('#paid').val()
      },
      success: function(data) {
        window.location.reload()
      },
      error: function(data) {
        debugger
        console.log(e)
      }
    });
  });
  // $("#show_notes").blur(function() {
  //   $.ajax({
  //       type: "POST",
  //       url: '/projects/update_note',
  //       data: { notes: $(this).notes() },
  //       dataType: 'script'
  //   })
  // });
// 
//  $('.table_header').css(backgroundcolor);
//  $(function() {
//    $( "#datepicker" ).datepicker({
//        minDate: 0
//        dateFormat: 'dd-mm-YYYY'
//     });
//  });
});
