$(document).ready(function() {
        
  $(".task_row").click(function() {
      $(this).next("tr.task_details").slideToggle("fast");
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
