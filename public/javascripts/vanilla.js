Vanilla = {
  linkEditorInputs: function() {
    $('input.attribute_name').change(function() {
      var dl_children = $('dl.attributes').children();
      var dt_index = dl_children.index(this.parentNode) + 1;
      var textarea_for_this = dl_children[dt_index].childNodes[0];
      textarea_for_this.name = this.value;
    });
    $('textarea').autogrow();
  },
  
  prepareEditor: function() {
    $('a#add').click(function() {
      $('dl.attributes').append('<dt><input class="attribute_name" type="text"></input></dt><dd><textarea></textarea></dd>');
      Vanilla.linkEditorInputs();
      return false;
    });
    Vanilla.linkEditorInputs();
  },
  
  setupAjaxDynasnips: function() {
    $('a.vanilla_ajax').hide().each(function() {
      var element = $(this);
      $.get(element[0].href + '.text', function(content) {
        element.after(content).remove();
      });
    });
  }
}

$(function() {
  Vanilla.prepareEditor();
  Vanilla.setupAjaxDynasnips();
});
