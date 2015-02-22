/***********************************
 * Aquí el código para CartoDB
 * (A continuación un ejemplo 
 * tomado de la documentación)
***********************************/

window.onload = function() {
  cartodb.createVis('map', 'http://documentation.cartodb.com/api/v2/viz/2b13c956-e7c1-11e2-806b-5404a6a683d5/viz.json')
  .done(function(vis, layers) {
    // layer 0 is the base layer, layer 1 is cartodb layer
    // when setInteraction is disabled featureOver is triggered
    layers[1].setInteraction(true);
    layers[1].on('featureOver', function(e, latlng, pos, data, layerNumber) {
      cartodb.log.log(e, latlng, pos, data, layerNumber);
    });

    // you can get the native map to work with it
    var map = vis.getNativeMap();

    // now, perform any operations you need, e.g. assuming map is a L.Map object:
    // map.setZoom(3);
    // map.panTo([50.5, 30.5]);
  });
}