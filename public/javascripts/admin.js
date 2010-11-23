var label_new = function() {
  new Ajax.Request(
      '/admin/labels/new', { asynchronous:false, evalScript:true, method:'get' } );
  lightbox.activate();
}

var label_edit = function(id) {
  var url = '/admin/labels/' + id + '/edit';
  new Ajax.Request( url, { asynchronous:false, evalScript:true, method:'get' } );
  lightbox.activate();
}

var image_selector = function() {
  var url = '/admin/images.json'
  var images = [];
  new Ajax.Request( url, { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) {
        images = response.responseJSON;
      }
    });

  // lightbox_contentsに流し込むelement
  var thumbs = Builder.node('div', { style: { width: '800' } });
  for (var i=0; i<images.length; i++) {
    var image = images[i].image;
    //var img_src = image.src;
    var thumb = Builder.node('div', { id: 'image_thumb' },
      //[Builder.node('img', { className: 's50', src: img_src })]);
      [Builder.node('p', image.filename)]);
    thumbs.insert( thumb );
  }
  thumbs.insert( Builder.node('div', { className: 'clear' }));
  $('lightbox_contents').insert( thumbs );

  lightbox.activate();
}
