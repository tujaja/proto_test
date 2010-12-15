// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
var switch_image = function(token, elm, size) {
  var url = '/images/up/' + token + '.' + size + '.jpg';
  $(elm).src = url;
}

var select_search_category = function(name) {
  $$('#search_category li a').invoke('removeClassName', 'focus');
  var class_name = '#search_category li a.' + name;
  $$(class_name).invoke('addClassName', 'focus');
  $('category').setValue(name);
}

var selftimer = function(handler, time) {
  //var flag = _flag || true;
  //var id;

  (function() {
    setTimeout(handler, time);
  })();

}

var blind_up_cart_item = function(elm) {
  //new Effect.Fade(elm);
  //new Effect.BlindUp(elm);

  //Element.wrap(elm, new Element('div', { id : 'bl_wrap'}));
  //new Effect.BlindUp($('bl_wrap'), {duration:1});
}


// show
var resource_show = function(resource, id) {
  var url = '/' + resource + '/' + id;
  new Ajax.Request( url, { asynchronous:false, evalScript:true, method:'get' } );
}

// update
var resource_update = function(resource, _id, _params) {
  var id = _id || "";
  var params = _params || {};
  var url;

  if (id == "") { url = '/' + resource; }
  else { url = '/' + resource + '/' + id; }

  new Ajax.Request( url, { asynchronous:false, evalScript:true, method:'put',
    parameters:params } );
}
