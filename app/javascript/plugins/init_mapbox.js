import mapboxgl from 'mapbox-gl';

// STYLES and CONFIGURATIONS:

const markerPopUp = (marker) => {
  return (
    `<a href ="${marker.pitch_link}">
    <h6>${marker.pitch_title}</h6>
    <p> Preço: ${marker.pitch_price}/hr</p>
    <img src="${marker.pitch_photo}" alt="" style="width:140px;height:120px;">
    </a>`
  )
};


const whereAmIPopUp = (marker) => {
  return (
    `<a href ="${marker.pitch_link}">
    <h6>Voce esta aqui</h6>
    </a>`
  )
};


const friendPopUp = (marker) => {
  return (
    `<h6>Seu Amigo esta aqui</h6>`
  )
};

const mapBoxSetup = () => {
  return(
    {
      container: 'map',
      style: 'mapbox://styles/mapbox/navigation-guidance-day-v4',
      zoom: 12,
      center: [-46.741735, -23.55762]
    }
  )
};

const polygonLayer = {
  "id": "polygon",
  "type": "fill",
  "source": "polygon",
  "layout": {
    'visibility': 'visible'
  },
  "paint": {
      "fill-color": "#CEE5D3",
      "fill-opacity": 0.6
  }
};

// const markerOptions = {color: 'red'};
// const whereAmIMarkerOptions = {color: 'red'};
const mapBounds = { padding: 70, maxZoom: 15 };

// end of STYLES and CONFIGURATIONS:

const mapElement = document.getElementById('map');

const buildMap = () => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map(mapBoxSetup());
};

const addCircleToMarker =(map, marker) => {

  if ( isNaN( max_dist.value )){ max_dist.value = 3 }; // sorry overwrites text in box
  if (max_dist.value < 0 || max_dist.value > 10) {max_dist.value = 10};
  const radiusInKm = parseInt(max_dist.value);

  // remove old polygon:
  if(typeof map.getLayer('polygon') !== 'undefined') {
    map.removeLayer('polygon').removeSource('polygon');
  }
  // make a new polygon:
  map.addSource("polygon", createGeoJSONCircle([marker.lng, marker.lat], radiusInKm, 64));
  map.addLayer(polygonLayer);
}

const addMarkersToMap = (map, markers) => {
  removeOldMarkers();
  window.oldmarkers = [];

  markers.forEach((marker) => {
  console.log(marker);
  // place makers of available items:
    if (marker.type == 1 ) { // CAMPOS
      var el = document.createElement('div');
      el.className = 'mapbox-pitch-marker';
      const popup = new mapboxgl.Popup().setHTML(markerPopUp(marker));
      //var markerTemp = new mapboxgl.Marker(markerOptions)
      var markerTemp = new mapboxgl.Marker(el)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
      oldmarkers.push(markerTemp);
    }
    // place the central marker:

    if (marker.type == 0 ) { // CENTRAL
      var el = document.createElement('div');
      el.className = 'mapbox-central-marker';
      const popup = new mapboxgl.Popup().setHTML(whereAmIPopUp(marker));
      markerTemp = new mapboxgl.Marker(el)
        .setLngLat([ marker.lng, marker.lat ])
        //.setPopup(popup)
        .addTo(map);
      map.panTo([ marker.lng, marker.lat ]);
      addCircleToMarker(map,marker);
      oldmarkers.push(markerTemp);
    }

    if (marker.type == 2 ) { // AMIGOS
      var el = document.createElement('div');
      el.className = 'mapbox-friends-marker';
      const popup = new mapboxgl.Popup().setHTML(friendPopUp(marker));
      markerTemp = new mapboxgl.Marker(el)
        .setLngLat([ marker.lng, marker.lat ])
        //.setPopup(popup)
        .addTo(map);
      oldmarkers.push(markerTemp);
    }
  });
};

const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  map.fitBounds(bounds, mapBounds);
};

const initMapbox = () => {

  if (mapElement) {
    window.map = buildMap();
    window.StopClick = false;
    window.map.on('load', function() {
      // get the markers from html
      const markers = JSON.parse(mapElement.dataset.markers);
      addMarkersToMap(window.map, markers);
    });
    // when mouse is in the polygon disable click to prevent deletion of the popup
    window.map.on('mouseenter', 'polygon', function(e) { window.StopClick = true;  });

    window.map.on('mouseleave', 'polygon', function(e) { window.StopClick = false; });

    window.map.on('click', function(e) {
      if( window.StopClick ) { return;}

      const myData =`lng=${e.lngLat.lng}&lat=${e.lngLat.lat}&max_dist=${max_dist.value}`;

      Rails.ajax({
                type: "GET",
                url: "/pitches_map",
                data: myData,
                contentType: "application/json",
                dataType: 'script',
              success: function (form) {
                //console.log("succes");
              }
       });
    });
  }
};

function onSuccess(result) {};

const removeOldMarkers = () => {
  if (typeof window.oldmarkers !== 'undefined'){
    window.oldmarkers.forEach((marker) => { marker.remove(); });
  }
};

window.addMarkersAfterClick = (map,markers) => {
  // entry point from AjAX return (.JS.ERB)
  addMarkersToMap(map,markers)
};

var createGeoJSONCircle = function(center, radiusInKm, points) {
    if(!points) points = 64;

    var coords = {
        latitude: center[1],
        longitude: center[0]
    };

    var km = radiusInKm;

    var ret = [];
    var distanceX = km/(111.320*Math.cos(coords.latitude*Math.PI/180));
    var distanceY = km/110.574;

    var theta, x, y;
    for(var i=0; i<points; i++) {
        theta = (i/points)*(2*Math.PI);
        x = distanceX*Math.cos(theta);
        y = distanceY*Math.sin(theta);

        ret.push([coords.longitude+x, coords.latitude+y]);
    }
    ret.push(ret[0]);
    return {
        "type": "geojson",
        "data": {
            "type": "FeatureCollection",
            "features": [{
                "type": "Feature",
                "geometry": {
                    "type": "Polygon",
                    "coordinates": [ret]
                }
            }]
        }
    };
};


export { initMapbox };

