//
//


// show
var resource_show = function(resource, id) {
  var url = '/admin/' + resource + '/' + id;
  new Ajax.Request( url, { asynchronous:false, evalScript:true, method:'get' } );
}

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
var select_search_salt = function(field, name) {
  var div = '#' + field
  $$(div + ' li a').invoke('removeClassName', 'focus');
  var class_name = 'div' + ' li a.' + name;
  $$(class_name).invoke('addClassName', 'focus');
  $(field).setValue(name);
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

  // Element
  var selector = Builder.node('div', { id: 'selector' },
    Builder.node('p', { className: 'title' }, '画像を選択してください'));
  for (var i=0; i<images.length; i++) {
    var image = images[i].image;
    var img_src = '/images/up/' + image.token + '.s50.jpg';
    var thumb = Builder.node('div', { className: 'image_thumb' },
    [Builder.node('a', { href: '#' }, 
      Builder.node('img', { className: 's50', src: img_src, height: '50px', width: '50px' })),
      Builder.node('p', image.filename)]);
    Event.observe($(thumb).select('img')[0], 'click',
    (function(img) {
      return function() {
        lightbox.deactivate(layer);
        handler(img);
      };
    })(image));

    selector.insert( thumb );
  }
  selector.insert( Builder.node('div', { className: 'clear' }));

  lightbox.lb_contents(layer).insert( selector );
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

  // Element
  var selector = Builder.node('div', { id: 'selector' },
    Builder.node('p', { className: 'title' }, 'レーベルを選択してください'));
  for (var i=0; i<labels.length; i++) {
    var label = labels[i].label;
    var record = Builder.node('div', { className: 'record' },
      [Builder.node('a', { href: '#' }).update(label.name)]);
    Event.observe($(record), 'click',
    (function(l) {
      return function() {
        lightbox.deactivate(layer);
        handler(l);
      };
    })(label));

    selector.insert( record );
  }

  lightbox.lb_contents(layer).insert( selector );
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
  var selector = Builder.node('div', { id: 'selector' },
    Builder.node('p', { className: 'title' }, 'アーティストを選択してください'));
  for (var i=0; i<artists.length; i++) {
    var artist = artists[i].artist;
    var record = Builder.node('div', { className: 'record' },
      [Builder.node('a', { href: '#' }).update(artist.name)]);  // need to escape
    Event.observe($(record), 'click',
    (function(l) {
      return function() {
        lightbox.deactivate(layer);
        handler(l);
      };
    })(artist));

    selector.insert( record );
  }

  lightbox.lb_contents(layer).insert( selector );
  lightbox.activate(layer);
}

var content_selector = function(_layer, handler) {
  var layer = _layer || 0;
  lightbox.setup(layer);

  var url = '/admin/contents.json';
  var contents = [];
  new Ajax.Request( url, { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) { contents = response.responseJSON; }
    });

  // lightbox_contentsに流し込むelement
  var selector = Builder.node('div', { id: 'selector' },
    Builder.node('p', { className: 'title' }, 'コンテンツを選択してください'));
  for (var i=0; i<contents.length; i++) {
    var content = contents[i].content;
    var record = Builder.node('div', { className: 'record' },
      [Builder.node('a', { href: '#' }).update(content.name)]);  // need to escape
    Event.observe($(record), 'click',
    (function(l) {
      return function() {
        lightbox.deactivate(layer);
        handler(l);
      };
    })(content));

    selector.insert( record );
  }

  lightbox.lb_contents(layer).insert( selector );
  lightbox.activate(layer);
}


var download_selector = function(_layer, handler) {
  var layer = _layer || 0;
  lightbox.setup(layer);

  var url = '/admin/downloads.json';
  var downloads = [];
  new Ajax.Request( url, { asynchronous:false, evalScripts:true, method:'get',
      onComplete: function(response) { downloads = response.responseJSON; }
    });

  // lightbox_contentsに流し込むelement
  var selector = Builder.node('div', { id: 'selector' },
    Builder.node('p', { className: 'title' }, 'ダウンロードファイルを選択してください'));
  for (var i=0; i<downloads.length; i++) {
    var download = downloads[i].download;
    var record = Builder.node('div', { className: 'record' },
      [Builder.node('a', { href: '#' }).update(download.filename)]);
    Event.observe($(record), 'click',
    (function(dl) {
      return function() {
        lightbox.deactivate(layer);
        handler(dl);
      };
    })(download));

    selector.insert( record );
  }

  lightbox.lb_contents(layer).insert( selector );
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
  var selector = Builder.node('div', { id: 'selector' },
    Builder.node('p', { className: 'title' }, '曲を選択してください'));
  for (var i=0; i<contents.length; i++) {
    var content = contents[i].content;
    var record = Builder.node('div', { className: 'record' },
      [Builder.node('a', { href: '#' }).update(content.name)]);
    Event.observe($(record), 'click',
    (function(l) {
      return function() {
        lightbox.deactivate(layer);
        handler(l);
      };
    })(content.attachable_info_id));

    selector.insert( record );
  }

  lightbox.lb_contents(layer).insert( selector );
  lightbox.activate(layer);
}




