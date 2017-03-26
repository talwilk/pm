$(function() {
  $('#dilemma_description').froalaEditor({
     toolbarButtons: ['emoticons', 'undo', 'redo', 'insertLink'],
      charCounterMax: app.vars.DILEMMA_DESCRIPTION,
      maxCharacters: app.vars.DILEMMA_DESCRIPTION,
      charCounterCount: true,
      multiLine: false,
      htmlSimpleAmpersand: true,
      pastePlain: true,
      emoticonsUseImage: false,
      placeholderText: $('#dilemma_description').attr('placeholder')
    });
  
  // var direction = $('.direction').text()
  // $($('fr-element fr-view').attr('dir', direction))
  // $('span.fr-placeholder').addClass(direction + ' alignment-type-something')
  var buttons = $('.fr-toolbar.fr-desktop.fr-top.fr-basic.fr-sticky.fr-sticky').find('button')
  
  for(i=0 ; i < buttons.length ; i ++)
  {
    var caption = $(buttons[i]).attr('data-cmd')
    var element = $('#description_tr .'+caption)
    if(element != null)
    {
      $(buttons[i]).attr('title', element.html())
    }
  }
  var direction = $('.direction').text()
  $('.fr-element.fr-view').attr('dir' ,direction);
  $('.fr-element.fr-view').addClass(direction);
  if($('span.fr-placeholder').html())
    {
      $('.fr-placeholder').addClass(direction  + ' placeholder-position');
    }
  $(".fr-command").click(function(){
    var buttonlink = $(".fr-dropdown")
    var captionlink = $(buttonlink).attr('data-cmd')
    $(buttonlink).attr('title', $("."+captionlink).html())
    var btnsubmit = $('.fr-command.fr-submit')
    var captionsubmit = $(btnsubmit).attr('data-cmd')
    $(btnsubmit).text($("."+captionsubmit).html())
    var urltext = $('.fr-link-attr')
    for(i=0 ; i < urltext.length - 1 ; i ++)
    {
      var caption = $(urltext[i]).attr('placeholder')
      var element = $('#description_tr .'+caption.toLowerCase())
      if(element != null)
      {
        $(urltext[i]).attr('placeholder', element.html())
      }
    }
    // froala, green, thick, facebook, google
    var dropdown = $('.fr-dropdown-wrapper .fr-dropdown-content .fr-dropdown-list .fr-command')
    for(i=0 ; i < dropdown.length ; i ++)
    {
      var caption = $(dropdown[i]).text()
      var element = $('#description_tr .'+caption.toLowerCase()).text()
      if(element != null)
      {
        $(dropdown[i]).text(element)
      }
    }
    //editlink, style, unlink, openlink
    $('.fr-command.fr-submit').click(function(){
      var popupbtns = $('.fr-popup.fr-desktop.fr-active .fr-buttons .fr-command.fr-btn')
      for(i=0 ; i < popupbtns.length ; i ++)
      {
        var captionbtn = $(popupbtns[i]).attr('data-cmd')
        var elementbtn = $('#description_tr .'+captionbtn)
        if(elementbtn != null)
        {
          $(popupbtns[i]).attr('title', elementbtn.html())
        }
      }
      var btnback = $('.fr-command.fr-btn.fr-back')
      var elementback = $(btnback.attr('data-cmd'))
      if(elementback != null)
      {
        $(btnback).attr('title', elementback.html())
      }
    })
    
    var checkbox = $('.fr-checkbox-line label')
    var caption = $(checkbox).text().replace(/\s+/g,'');
    var element = $('#description_tr .'+caption.toLowerCase()).text()
    $(checkbox).text(element)
      
  })

  $('#dilemma_description').one('froalaEditor.keypress', function (e, editor, keypressEvent) {
    var direction = $('.direction').text()
    $('.fr-counter').insertAfter('.dilemma_description label').addClass('maxlength-feedback ' + direction + ' alignment-counter');
    $('.fr-element.fr-view').attr('dir' ,direction);
    $('.fr-element.fr-view').addClass(direction);
    if($('span.fr-placeholder').html())
    {
      $('.fr-placeholder').addClass(direction  + ' placeholder-position');
    }
  });

 $('.has-error').click(function () {
    $(this).removeClass('has-error');
  });

 // Reset custom form fields
 $('button:reset').click(function () {
    $('.nested-fields').remove();
    $('.maxlength-feedback').empty();
    $('#dilemma_category_list').select2('val', '');
  });

 // Edit dilemma form
  $('#edit-dilemma .submit-button').click(function () {
    $('.dilemma-edit-form-submit').click();
  });

});
