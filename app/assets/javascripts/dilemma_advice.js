$.FroalaEditor.DEFAULTS.key = app.vars.FROALA_LICENSE_KEY;
function initializeDilemmaAdvice(){
  // $.FroalaEditor.DefineIcon('froala-action-button', {NAME: ''});
  $.FroalaEditor.DefineIconTemplate('textWithClass', '<span class="[CLASS]" id="[ID]">[NAME]</span>');
  $.FroalaEditor.DefineIcon('froala-action-button', {NAME: 'ADD ADVICE', CLASS: 'froala-action-button', ID: 'advice-button', template: 'textWithClass'});
  $.FroalaEditor.RegisterCommand('froala-action-button', {
      title: '',
      focus: true,
      undo: true,
       callback: function () {
         this.$oel.closest('form').submit();
       }
    });

  $.FroalaEditor.DefineIcon('froala-attach-button', {NAME: 'paperclip', template: 'font_awesome'});
  $.FroalaEditor.RegisterCommand('froala-attach-button', {
      title: 'Add media',
      focus: true,
      undo: true,
      callback: function () {
          $(this.$oel[0]).parent().parent().parent().find('.media').toggleClass('uk-hidden');
      }
    });

  $('#dilemma_advice_content').froalaEditor({
    toolbarButtons: ['emoticons', 'undo', 'redo', 'insertLink', 'froala-attach-button', 'froala-action-button'],
      multiLine: false,
      htmlSimpleAmpersand: true,
      pastePlain: true,
      emoticonsUseImage: false,
      placeholderText: $('#dilemma_advice_content').attr('placeholder')
  });

  var buttons = $('.fr-toolbar.fr-desktop.fr-top.fr-basic.fr-sticky.fr-sticky').find('button')
  
  for(i=0 ; i < buttons.length ; i ++)
  {
    var caption = $(buttons[i]).attr('data-cmd')
    var element = $('#content_tr .'+caption)
    if(element != null)
    {
      $(buttons[i]).attr('title', element.html())
    }
  }

  var direction = $('.direction').text()
  $('.fr-element.fr-view').attr('dir' ,direction);
  $('.fr-element.fr-view').addClass(direction);
  $('.fr-placeholder').addClass(direction  + ' placeholder-position');
  
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
      var element = $('#content_tr .'+caption.toLowerCase())
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
      var element = $('#content_tr .'+caption.toLowerCase()).text()
      if(element != null)
      {
        $(dropdown[i]).text(element)
      }
    }
    //editlink, style, unlink, openlink
    var popupbtns = $('.fr-popup.fr-desktop.fr-active .fr-buttons .fr-command.fr-btn')
    for(i=0 ; i < popupbtns.length ; i ++)
    {
      var captionbtn = $(popupbtns[i]).attr('data-cmd')
      var elementbtn = $('#content_tr .'+captionbtn)
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

    var checkbox = $('.fr-checkbox-line label')
    var caption = $(checkbox).text().replace(/\s+/g,'');
    var element = $('#content_tr .'+caption.toLowerCase()).text()
    $(checkbox).text(element)
  })

  var caption_action = $('.froala-action-btn').text()
  var btn_text = $('#advice-button').html(caption_action)
  var direction = $('.direction').text()
  $('.froala-action-button').parent().addClass(direction + ' auto-margin');

  $(".new_dilemma_advice").submit(function () {
    $('#advice-button').replaceWith("<span class='froala-action-button uk-flex uk-flex-middle uk-center' id='advice-button'><i class='uk-icon-spinner uk-icon-spin uk-text-center'></i></span>");
    $('button[data-cmd="froala-action-button"]').prop("disabled", true);
  });
}

$(function() {
  initializeDilemmaAdvice();
  var caption_action = $('.froala-action-btn').text()
  var btn_text = $('#advice-button').html(caption_action)
  var direction = $('.direction').text()
  $('.froala-action-button').parent().addClass(direction + ' auto-margin');
});
$('.nested-fields.filled').prependTo('.uk-grid.medias')
