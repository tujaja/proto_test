var resource_new = function(resource) {
  lightbox.setup();
  new Ajax.Request(
      '/admin/' + resource + '/new', { asynchronous:false, evalScript:true, method:'get' } );
  lightbox.activate();
}

var resource_edit = function(resource, id) {
  lightbox.setup();
  var url = '/admin/' + resource + '/' + id + '/edit';
  new Ajax.Request( url, { asynchronous:false, evalScript:true, method:'get' } );
  lightbox.activate();
}

var image_selector = function(_layer, handler) {
  var layer = _layer || 0;
  lightbox.setup(layer);

  var url = '/admin/images.json';
  var images = [];
  new Ajax.Request( url, { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) { images = response.responseJSON; }
    });

  // lightbox_contentsに流し込むelement
  var thumbs = Builder.node('div', { className: 'thumbs' });
  thumbs.setStyle({width:'800px'});
  for (var i=0; i<images.length; i++) {
    var image = images[i].image;
    var img_src = '/images/up/' + image.token + '.s50.jpg';
    var thumb = Builder.node('div', { id: 'image_thumb' },
      [Builder.node('img', { classname: 's50', src: img_src, height: '50', width: '50' }),
      Builder.node('p', image.filename)]);
    Event.observe($(thumb).select('img')[0], 'click',
    (function(img) {
      return function() {
        lightbox.deactivate(layer);
        handler(img);
      };
    })(image));

    thumbs.insert( thumb );
  }
  thumbs.insert( Builder.node('div', { className: 'clear' }));

  lightbox.lb_contents(layer).insert( thumbs );
  lightbox.activate(layer);
}

var label_selector = function(_layer, handler) {
  var layer = _layer || 0;
  lightbox.setup(layer);

  var url = '/admin/labels.json';
  var labels = [];
  new Ajax.Request( url, { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) { labels = response.responseJSON; }
    });

  // lightbox_contentsに流し込むelement
  var records = Builder.node('div', { className: 'records' });
  records.setStyle({width:'400px'});
  for (var i=0; i<labels.length; i++) {
    var label = labels[i].label;
    var row = Builder.node('div', { id: 'record' },
      [Builder.node('p', label.name)]);
    Event.observe($(row), 'click',
    (function(l) {
      return function() {
        lightbox.deactivate(layer);
        handler(l);
      };
    })(label));

    records.insert( row );
  }

  lightbox.lb_contents(layer).insert( records );
  lightbox.activate(layer);
}

var artist_selector = function(_layer, handler) {
  var layer = _layer || 0;
  lightbox.setup(layer);

  var url = '/admin/artists.json';
  var artists = [];
  new Ajax.Request( url, { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) { artists = response.responseJSON; }
    });

  // lightbox_contentsに流し込むelement
  var records = Builder.node('div', { className: 'records' });
  records.setStyle({width:'400px'});
  for (var i=0; i<artists.length; i++) {
    var artist = artists[i].artist;
    var row = Builder.node('div', { id: 'record' },
      [Builder.node('p', artist.name)]);
    Event.observe($(row), 'click',
    (function(l) {
      return function() {
        lightbox.deactivate(layer);
        handler(l);
      };
    })(artist));

    records.insert( row );
  }

  lightbox.lb_contents(layer).insert( records );
  lightbox.activate(layer);
}
