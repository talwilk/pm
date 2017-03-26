$(function() {

  // select2 init
  $('select').select2({
    minimumResultsForSearch: -1
  });

  $('#dilemma_category_list, select#category').select2({
    placeholder: $('select#category').attr('placeholder'),
    minimumResultsForSearch: -1
  });

  $('select#sort_by').select2({
    placeholder: $('select#sort').attr('placeholder'),
    minimumResultsForSearch: -1
  });

  $('select#dilemmas').select2({
    placeholder: $('select#dilemmas').attr('placeholder'),
    minimumResultsForSearch: -1
  });

  $(window).click(function() {
    $("select").select2("close");
  });

  $('.select2, .select2-results').click(function(event){
    event.stopPropagation();
  });


  $('.tooltip').tooltipster({
    contentAsHTML: true,
    interactive: true,
    side: 'bottom',
    animation: 'grow'
  });

  $('#top-search').on('click', function(){
   $(this).find('input').focus();
  });

  $('.fb').on('click', function(){
    FB.ui({
      method: 'share',
      display: 'popup',
      href: 'https://developers.facebook.com/docs/',
    }, function(response){});
    });


  if ($('#flash_gamification').length ) {
    $('.notification-holder .gamification-notice').remove();
    $('#flash_gamification').insertAfter($('.top-user-rank'));
    $('.gamification-notice').tooltipster('open');
    setTimeout(function() {
       $('.gamification-notice').tooltipster('destroy');
    }, 3000);
  }

  $('#user-menu .uk-button-dropdown').click(function(){
    $(this).toggleClass('uk-open');
  });

  $('.nested-fields.filled').prependTo('.uk-grid.medias');
  $('span.selection').css("display", "block");
});

$(document).on('click', function (e) {
  if ($(e.target).closest(".uk-nav-dropdown, .uk-button-dropdown").length === 0) {
    $("#user-menu .uk-button-dropdown").removeClass('uk-open');
  }
});
function responsive_image() {
    $('img.responsive').responsive_images({
        mobile_size: 768,
        desktop_size: 980
    });
}
responsive_image();
