var Lightbox = Class.create();

Lightbox.prototype = {
  initialize: function() {

    this.overlay_duration = 0.1;
    this.overlay_opacity = 0.8;
    this.overlay_zindex = tt.overlay_style.zIndex;

    this.create_overlay_element();
  },

  setup : function(_layer) {
    var layer = _layer || 0;
    this.create_lightbox_element(layer);
  },

  create_overlay_element: function() {
    $(document.body)
    .insert( new Element('div', { id : 'overlay' }).setStyle( tt.overlay_style ).hide() );
  },

  create_lightbox_element: function(_layer) {
    var layer = _layer || 0;

    var lb = new Element('div', {id: this.id(layer)}).setStyle( tt.lb_style );

    // 指定した位置に出せた方が良いのである
    var array_pagescroll = document.viewport.getScrollOffsets();
    var lb_top = array_pagescroll[1] + (document.viewport.getHeight() / 10) + layer*10;
    var lb_left = array_pagescroll[0];
    lb.setStyle({ top: lb_top + 'px', left: lb_left + 'px', zIndex: this.lb_zindex(layer) })
      .show();

    var lb_frame = new Element('div', {className: 'lb-frame'}).setStyle( tt.lb_frame_style );
    var lb_contents = new Element('div', {className : 'lb-contents'}); // 目印として
    var lb_close = new Element('div', {className : 'lb-close'}).setStyle( tt.lb_close_style );
    lb_close.update(
      new Element('a', {href: "#"}).update(
        new Element('img', { src: '/images/close.jpg', width:'16px', height:'16px' } )));

    Event.observe( lb_close, 'click',
      (function(self, l) {
        return function() { self.deactivate(l); };
      })(this, layer)
    );

    lb_frame.insert(lb_close);
    lb_frame.insert(lb_contents);
    lb.insert(lb_frame);

    $(document.body).insert(lb);
    lb.hide();
  },

  // dispay overlay and lightbox
  activate: function(_layer) {
    var layer = _layer || 0;

    // overlay setting
    if (layer == 0) {
      var doc_sizes = this.document_pagesize();
      $('overlay').setStyle({ width: doc_sizes[0] + 'px', height: doc_sizes[1] + 'px' });
      $('overlay').appear({ duration: this.overlay_duration, from: 0.0, to: this.overlay_opacity });
    } else {
      $('overlay').setStyle({ zIndex: this.lb_zindex(layer)-1 });
    }

    var w =  this.lb_contents(layer).firstDescendant().getStyle('width');
    this.lb_frame(layer).setStyle({ width: w, height: '100%' });
    this.lb(layer).show();
  },

  deactivate: function(_layer, _duration) {
    var layer = _layer || 0;
    var dur = _duration || this.overlay_duration;

    var contents = this.lb_contents(layer);
    if (contents) { contents.remove(); }
    this.lb(layer).remove();
    if (layer == 0) {
      $('overlay').fade( { duration: dur });
    } else {
      $('overlay').setStyle({ zIndex: this.lb_zindex(layer-1)-1 });
    }
  },

  document_pagesize: function() {
    var x_scroll, y_scroll;
    x_scroll = window.innerWidth + window.scrollMaxX;
    y_scroll = window.innerHeight + window.scrollMaxY;

    var window_width, window_height;
    window_width = document.documentElement.clientWidth;
    window_height = document.documentElement.clientHeight;

    var page_width, page_height;
    // for small pages with total height less than height of the viewport
    if (y_scroll < window_height) {
      page_width = window_height;
    } else {
      page_height = y_scroll;
    }

    // for small pages with total width less than width of the viewport
    if (x_scroll < window_width) {
      page_width = x_scroll;
    } else {
      page_width = window_width;
    }
    return [page_width,page_height];
  },

  id : function(_layer) {
    var layer = _layer || 0;
    return 'lightbox-' + layer.toString();
  },
  lb : function(_layer) {
    var layer = _layer || 0;
    return $(this.id(layer));
  },
  lb_frame : function(_layer) {
    var layer = _layer || 0;
    return this.lb(layer).select('div.lb-frame')[0];
  },

  lb_contents : function(_layer) {
    var layer = _layer || 0;
    var l = this.lb(layer);
    var s = l.select('div.lb-contents');
    return this.lb(layer).select('div.lb-contents')[0];
  },

  lb_contents_size : function(_layer) {
    var layer = _layer || 0;

    var width = 0;
    var height = 0;
    var contents = this.lb_contents(layer);
    if(contents != null) {
      width = contents.getStyleWidth();
      height = contents.getHeight();
    }
    return [width, height];
  },

  lb_zindex : function(_layer) {
    var layer = _layer || 0;
    return eval(tt.lb_style.zIndex) + (layer*10);
  }

}

var lightbox = null;

document.observe('dom:loaded', function () {
  lightbox = new Lightbox();
});

var tt = {}

tt.overlay_style = {
  position: 'absolute',
  top: '0',
  left: '0',
  width: '100%',
  height: '100%',
  zIndex:'1000',
  backgroundColor:'#333'
}

tt.lb_style = {
  position: 'absolute',
  top: '0',
  left: '0',
  width: '100%',
  zIndex:'2000'
}

tt.lb_frame_style = {
  position: 'relative',
  margin: '0px auto', // necessery
  padding: '20px',
  border: '5px solid #333',
  backgroundColor: '#FFF'
}

tt.lb_close_style = {
  position: 'absolute',
  top: '5px',
  right: '5px'
}

