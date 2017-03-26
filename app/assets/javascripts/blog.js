$.FroalaEditor.DEFAULTS.key = app.vars.FROALA_LICENSE_KEY;
$(function() {
  $('#blog_post_content').froalaEditor({
        toolbarButtons: ['bold', 'italic', 'underline', 'strikeThrough', 'emoticons', '|', 'undo', 'redo', 'html', 'insertLink']
  });
});
