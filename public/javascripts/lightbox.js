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
  textAlign: 'left',
  zIndex:'1001'
}

tt.lb_frame_style = {
  position: 'relative',
  margin: '0px auto',
  padding: '20px',
  border: '5px solid #333',
  backgroundColor: '#FFF'
}


////////////////////////////////////////////////////

var Lightbox = Class.create();

Lightbox.prototype = {
  initialize: function() {

    this.overlayDuration = 0.2;
    this.overlayOpacity = 0.8;

    this.createOverlayElement();
    this.createLightBoxElement();

  },

  // dispay overlay and lightbox
  activate: function() {

    var arrayPageSize = this.getPageSize();
    $('overlay').setStyle({ width: arrayPageSize[0] + 'px', height: arrayPageSize[1] + 'px' });
    $('overlay').appear({ duration: this.overlayDuration, from: 0.0, to: this.overlayOpacity });

    // calculate top and left offset for the lightbox
    var arrayPageScroll = document.viewport.getScrollOffsets();
    var lightBoxTop = arrayPageScroll[1] + (document.viewport.getHeight() / 10);
    var lightBoxLeft = arrayPageScroll[0];
    $('lightbox').setStyle({ top: lightBoxTop + 'px', left: lightBoxLeft + 'px' }).show();

    // calculate lightbox contents size
    var contentsSize = this.getContentsSize();
    $('lightbox_frame').setStyle({ width: contentsSize[0]  + 'px', Height: contentsSize[1]  + 'px'} );

    $('lightbox').appear();

  },

  deactivate: function() {
    if ($('lightbox_contents').firstDescendant()) {
      $('lightbox_contents').firstDescendant().remove();
    }
    //if ($('lightbox_contents').descendants()) {
     //$('lightbox_contents').descendants().invoke('remove')
    //}
    $('lightbox').hide();
    $('overlay').fade( { duration: this.overlayDuration });
  },

  getContentsSize: function() {
    var contents = $('lightbox_contents').firstDescendant();
    var contentsWidth = 0;
    var contentsHeight = 0;
    if(contents != null) {
      contentsWidth = contents.getWidth();
      contentsHeight = contents.getHeight();
    }
    return [contentsWidth, contentsHeight];
  },

  getPageSize: function() {
    var xScroll, yScroll;
    xScroll = window.innerWidth + window.scrollMaxX;
    yScroll = window.innerHeight + window.scrollMaxY;

    var windowWidth, windowHeight;
    windowWidth = document.documentElement.clientWidth;
    windowHeight = document.documentElement.clientHeight;

    // for small pages with total height less than height of the viewport
   if (yScroll < windowHeight) {
      pageWidth = windowHeight;
    } else {
      pageHeight = yScroll;
    }

    // for small pages with total width less than width of the viewport
    if (xScroll < windowWidth) {
      pageWidth = xScroll;
    } else {
      pageWidth = windowWidth;
    }

    return [pageWidth,pageHeight];
  },

  createOverlayElement: function() {
   var overlay = new Element('div', { id : 'overlay' });
    overlay.setStyle( tt.overlay_style );
    $('wrapper').insert(overlay);
    $('overlay').hide();
  },

  createLightBoxElement: function() {
    // create lightbox element
    var lb = new Element('div', {id: 'lightbox'});
    lb.setStyle( tt.lb_style );
    var lb_frame = new Element('div', {id: 'lightbox_frame'});
    lb_frame.setStyle( tt.lb_frame_style );
    var lb_contents = new Element('div', {id : 'lightbox_contents'});
    close = new Element('a', {href: "#", onclick: "lightbox.deactivate();; return false;"});
    close.insert('close');

    lb_frame.insert(close);
    lb_frame.insert(lb_contents);
    lb.insert(lb_frame);

    $('wrapper').insert(lb);
    lb.hide();
  }
}

var lightbox = null;

document.observe('dom:loaded', function () {
  lightbox = new Lightbox();
});
