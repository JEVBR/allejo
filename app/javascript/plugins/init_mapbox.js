import mapboxgl from 'mapbox-gl';

const mapElement = document.getElementById('map');

const buildMap = () => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v10',
    zoom: 12,
//    center: [-46.741735, -23.55762]
  });
};


const addPopUps = (marker) => {
  console.log(marker.pitch_link);
  const popup = new mapboxgl.Popup()
                  .setHTML(`<a href ="${marker.pitch_link}">
                              <h6>${marker.pitch_title} - R$${marker.pitch_price}</h6>
                              <p>${marker.pitch_address}</p>
                              <img src="${marker.pitch_photo}" alt="No photos" style="width:200px;height:200px;">
                            </a>`);

  return popup;
};

const addWhereAmI = (marker) => {
  const popup = new mapboxgl.Popup()
                  .setHTML(`<a href ="${marker.pitch_link}">
                            <h6>Voce esta aqui</h6>
                            </a>`);
  return popup;
};

const addCircleToMarker =(map, marker) => {
  console.log("Adding circle to map at:" + marker);
  const radiusInKm = 5;

  var mapLayer = map.getLayer('polygon');

  if(typeof mapLayer !== 'undefined') {
    // Remove map layer & source.
    map.removeLayer('polygon').removeSource('polygon');
  }

  map.addSource("polygon", createGeoJSONCircle([marker.lng, marker.lat], radiusInKm, 64));
  map.addLayer({
    "id": "polygon",
    "type": "fill",
    "source": "polygon",
    "layout": {
      'visibility': 'visible'
    },
    "paint": {
        "fill-color": "pink",
        "fill-opacity": 0.6
    }
  });
}

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {
    console.log(marker)
    if (marker.home) {
      const popup = addPopUps(marker)
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
      map.jumpTo({ center: [ marker.lng, marker.lat ] });
    } else{
      const popup = addWhereAmI(marker)
      new mapboxgl.Marker({color: 'red'})
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
        addCircleToMarker(map,marker);
      map.easeTo({ center: [ marker.lng, marker.lat ] });
    }
  });
};



const fitMapToMarkers = (map, markers) => {
  const bounds = new mapboxgl.LngLatBounds();
  markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
  map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
};


const initMapbox = () => {

  if (mapElement) {
    const map = buildMap();
    // initSearchForm(map);
    map.on('load', function() {
      console.log("sarsf");
      const markers = JSON.parse(mapElement.dataset.markers);
      addMarkersToMap(map, markers);
    });
    map.on('click', function(e) {
    console.log("Clicked at:" + e.lngLat.lng + " / " + e.lngLat.lat);
    //const radiusInKm=5;
    //addCircleToMarker(map,[ e.lngLat.lng, e.lngLat.lat ]);
    //console.log(createGeoJSONCircle([ e.lngLat.lng, e.lngLat.lat ], radiusInKm, 64));

    addCircleToMarker(map,[e.lngLat.lng, e.lngLat.lat]);
    map.panTo([e.lngLat.lng, e.lngLat.lat]);
    //map.getSource('polygon').setData(createGeoJSONCircle([ e.lngLat.lng, e.lngLat.lat ], radiusInKm, 64));
});
  }
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
    console.log(ret);
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

