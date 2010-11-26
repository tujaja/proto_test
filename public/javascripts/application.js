// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//

var ElementHelper = {
  update_image: function(token, elm, size) {
    var url = '/images/up/' + token + '.' + size + '.jpg';
    $(elm).src = url;
  }
}


var ArtistSelector = Class.create();

ArtistSelector.prototype = {
  initialize: function() {
    var resources = getArtistResources();
  //  var element = build();
  },

  activate: function() {
    lightbox.appear();
  },

  getArtistResources: function() {
  }

}

document.observe('dom:loaded', function () {
  artist_selector = new ArtistSelector();
});
