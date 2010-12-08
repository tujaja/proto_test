// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
var switch_image = function(token, elm, size) {
  var url = '/images/up/' + token + '.' + size + '.jpg';
  $(elm).src = url;
}
