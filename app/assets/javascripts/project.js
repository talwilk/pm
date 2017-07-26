$(document).ready(function() {
  jQuery(".best_in_place").best_in_place();
  $(".task_row").click(function() {
      $(this).next("tr.task_details").slideToggle("fast");
  });

  $(".show_task_details").click(function() {
    task_id = $(this).data("task-id")
    this_class = $(this)
    if($(this).children('i').hasClass('fa-plus'))
    {
      $.ajax({
        type: "GET",
        url: '/task_detail/'+task_id,
        dataType : 'html',
        success: function(data) {
          $('*[data-task-id='+task_id+']tr.task_details').html(data);
          if ($('.mobile').data("mobile") == true) {
            this_class.parent().parent('tr').next("tr.task_details").slideToggle("fast");
          } else {
            this_class.parent('tr').next("tr.task_details").slideToggle("fast");
          }
          this_class.children('i').removeClass('fa-plus')
          this_class.children('i').addClass('fa-minus')

          $('*[data-task-id='+task_id+']tr.task_details #show_notes .notes_link').magnificPopup({
            type: 'inline',
            preloader: false,
            focus: '#notes',
            callbacks: {
              beforeOpen: function(elem) {
                if($(window).width() < 700) {
                  this.st.focus = false;
                } else {
                  this.st.focus = '#notes';
                }
              }
            }
          });
        },
        error: function(data) {
          
        }
      });
    } else {
      this_class.children('i').addClass('fa-plus')
      this_class.children('i').removeClass('fa-minus')
      if ($('.mobile').data("mobile") == true) {
        this_class.parent().parent('tr').next("tr.task_details").slideToggle("fast");
      } else {
        this_class.parent('tr').next("tr.task_details").slideToggle("fast");
      }
    }
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
      url: '/update_task/'+task_id,
      data: {
        task: {cost: $('#cost').val(), paid: $('#paid').val()}
      },
      success: function(data) {
        window.location.reload()
      },
      error: function(data) {
        console.log(e)
      }
    });
  });


  $('.invite_pro_btn').click(function(event){
    event.preventDefault();
    $('#invite_pro_submit').attr("task-id", $(this).data("task-id"))
    $('#invite_pro_submit').attr("project-id", $(this).data("project-id"))
    $('.add_new_professional').attr("task-id", $(this).data("task-id"))
    $('.add_new_professional').attr("project-id", $(this).data("project-id"))
    $('#guru').val($(this).data("pro-id")).trigger('change');
  });

  $('.invite_pro_btn').magnificPopup({
    type: 'inline',
    preloader: false,
    focus: '#guru',
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

  $('#invite_pro_submit').click(function(){
    task_id = $(this).attr("task-id")
    project_id = $(this).attr("project-id")
    $.ajax({
      type: "POST",
      url: '/projects/'+project_id+'/tasks/'+task_id+'/pros/assign_task',
      data: {
        pro_id: $('#guru').val(),
      },
      success: function(data) {
        window.location.reload()
      },
      error: function(data) {
        alert("Please Select Professional.")
        console.log(e)
      }
    });
  });

  $('.add_new_professional').click(function(){
    $('#new_professional #first_name').val('')
    $('#new_professional #last_name').val('')
    $('#new_professional #mobile_phone').val('')
    $('#new_professional #email').val('')
    $('#new_professional #task_id').val($(this).attr('task-id'))
    // $('#new_professional #project_id').val($(this).attr('project-id'))
  });

  $('.add_new_professional').magnificPopup({
    type: 'inline',
    preloader: false,
    focus: '#first_name',
    callbacks: {
      beforeOpen: function(elem) {
        if($(window).width() < 700) {
          this.st.focus = false;
        } else {
          this.st.focus = '#first_name';
        }
      }
    }
  });
});

$(document).on('click', '#show_notes .notes_link', function(){
  $('#notes').val($(this).data("notes"))
  $('#notes_submit').attr("task-id", $(this).data("task-id"))
});

$(document).on('click', '#notes_submit', function(){
  task_id = $(this).attr("task-id")
  $.ajax({
    type: "POST",
    url: '/update_task/'+task_id,
    data: {
      task: {notes: $('#notes').val()}
    },
    success: function(data) {
      window.location.reload()
    },
    error: function(data) {
      console.log(e)
    }
  });
});