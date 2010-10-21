// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//

var ElementHelper = {
  select_image: function(control, elm, size) {
    var image_token = $(control).getValue();
    var url = '/images/up/' + image_token + '.' + size + '.jpg';
    $(elm).src = url;
  }
}

