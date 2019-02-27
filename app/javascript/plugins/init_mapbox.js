import mapboxgl from 'mapbox-gl';

// STYLES and CONFIGURATIONS:

const markerPopUp = (marker) => {
  return (
    `<a href ="${marker.pitch_link}">
    <h6>${marker.pitch_title} - R$${marker.pitch_price}</h6>
    <p>${marker.pitch_address}</p>
    <img src="${marker.pitch_photo}" alt="No photos" style="width:200px;height:200px;">
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

const mapBoxSetup = () => {
  return(
    {
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v10',
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
      "fill-color": "#F4F4F4",
      "fill-opacity": 0.6
  }
};

const markerOptions = {color: 'green'};
const whereAmIMarkerOptions = {color: 'red'};
const mapBounds = { padding: 70, maxZoom: 15 };

// end of STYLES and CONFIGURATIONS:

const mapElement = document.getElementById('map');

const buildMap = () => {
  mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
  return new mapboxgl.Map(mapBoxSetup());
};

const addCircleToMarker =(map, marker) => {
  // console.log("Adding circle to map at:" + marker);
  const radiusInKm = parseInt(max_dist.value);
  //console.log(parseInt(max_dist.value));
  if(typeof map.getLayer('polygon') !== 'undefined') {
    map.removeLayer('polygon').removeSource('polygon');
  }

  map.addSource("polygon", createGeoJSONCircle([marker.lng, marker.lat], radiusInKm, 64));
  map.addLayer(polygonLayer);
}

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {

    if (marker.home) {
      const popup = new mapboxgl.Popup().setHTML(markerPopUp(marker));
      new mapboxgl.Marker(markerOptions)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
      map.jumpTo({ center: [ marker.lng, marker.lat ] });

    } else{
      const popup = new mapboxgl.Popup().setHTML(whereAmIPopUp(marker));
      new mapboxgl.Marker(whereAmIMarkerOptions)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
        addCircleToMarker(map,marker);
      map.jumpTo({ center: [ marker.lng, marker.lat ] });
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
    const map = buildMap();

    map.on('load', function() {
      const markers = JSON.parse(mapElement.dataset.markers);
      addMarkersToMap(map, markers);
    });

    map.on('click', function(e) {
    const place = { lng: e.lngLat.lng, lat: e.lngLat.lat};
    addCircleToMarker(map,place);
    map.panTo([e.lngLat.lng, e.lngLat.lat]);
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

