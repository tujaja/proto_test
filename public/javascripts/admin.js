// new
var resource_new = function(resource) {
  new Ajax.Request(
      '/admin/' + resource + '/new', { asynchronous:false, evalScript:true, method:'get' } );
}

// edit
var resource_edit = function(resource, id, _command)  {
  var command = _command || 'edit'; // or 'edit_images'
  var url = '/admin/' + resource + '/' + id + '/' + command;
  new Ajax.Request( url, { asynchronous:false, evalScript:true, method:'get' } );
}

// update
var resource_update = function(resource, id, _params) {
  var params = _params || {};
  var url = '/admin/' + resource + '/' + id;

  new Ajax.Request( url, { asynchronous:false, evalScript:true, method:'put',
    parameters:params } );
}

/////////////////////////////////////////////////////////////////////////////////////


var image_selector = function(_layer, handler) {
  var layer = _layer || 0;
  lightbox.setup(layer);

  var url = '/admin/images.json';
  var images = [];
  new Ajax.Request( url, { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) { images = response.responseJSON; }
    });

  // lightbox_contentsに流し込むelement
  var thumbs = Builder.node('div', { id: 'image_selector' });
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
  var records = Builder.node('div', { id: 'selector' });
  for (var i=0; i<labels.length; i++) {
    var label = labels[i].label;
    var row = Builder.node('div', { className: 'record' },
      [Builder.node('a', { href: '#' }).update(label.name)]);
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
  var records = Builder.node('div', { id: 'selector' });
  for (var i=0; i<artists.length; i++) {
    var artist = artists[i].artist;
    var row = Builder.node('div', { className: 'record' },
      [Builder.node('a', { href: '#' }).update(artist.name)]);
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


var music_selector = function(_layer, artist_id,  handler) {
  var layer = _layer || 0;
  lightbox.setup(layer);

  var url = '/admin/contents/musics/' + artist_id + '.json';
  var contents = [];
  new Ajax.Request( url, { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) { contents = response.responseJSON; }
    });

  // lightbox_contentsに流し込むelement
  var records = Builder.node('div', { id: 'selector' });
  for (var i=0; i<contents.length; i++) {
    var content = contents[i].content;
    var row = Builder.node('div', { className: 'record' },
      [Builder.node('a', { href: '#' }).update(content.name)]);
    Event.observe($(row), 'click',
    (function(l) {
      return function() {
        lightbox.deactivate(layer);
        handler(l);
      };
    })(content.attachable_info_id));

    records.insert( row );
  }

  lightbox.lb_contents(layer).insert( records );
  lightbox.activate(layer);
}

