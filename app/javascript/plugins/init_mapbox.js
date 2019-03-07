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

// not used now
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
  console.log("Adding circle to map at:" + marker);
  // const radiusInKm = parseInt(max_dist.value);
  const radiusInKm = parseInt(2);
  //console.log(parseInt(max_dist.value));
  if(typeof map.getLayer('polygon') !== 'undefined') {
    map.removeLayer('polygon').removeSource('polygon');
  }

  map.addSource("polygon", createGeoJSONCircle([marker.lng, marker.lat], radiusInKm, 64));
  map.addLayer(polygonLayer);
}

 const addMarkersToMap = (map, markers) => {
   //console.log("markers:" + markers);
  // console.log(map);
  removeOldMarkers();
  window.oldmarkers = [];
  markers.forEach((marker) => {
    console.log(marker);
    if (marker.home) {
      const popup = new mapboxgl.Popup().setHTML(markerPopUp(marker));
      var test = new mapboxgl.Marker(markerOptions)
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
      //map.jumpTo({ center: [ marker.lng, marker.lat ] });
      //console.log(test);

      test.on('mouseover', function(e) {
   // popup opened so we fire an event
          console.log("popop");
        });

      oldmarkers.push(test);
    } else{
      const popup = new mapboxgl.Popup().setHTML(whereAmIPopUp(marker));
      test = new mapboxgl.Marker(whereAmIMarkerOptions)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);
        addCircleToMarker(map,marker);
    //  const place = { lng: e.lngLat.lng, lat: e.lngLat.lat};
    //  addCircleToMarker(window.map,place);
    //  window.map.panTo([e.lngLat.lng, e.lngLat.lat]);


     // map.jumpTo({ center: [ marker.lng, marker.lat ] });
          oldmarkers.push(test);
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
      const markers = JSON.parse(mapElement.dataset.markers);
      markers.forEach((marker) => {
        console.log(marker);
        if (marker.home) {
          console.log("skip")
        } else {
          console.log("map redraw, move to center")
          map.jumpTo({ center: [ marker.lng, marker.lat ] });
        }
      });
      addMarkersToMap(window.map, markers);
    });
// draw a circle on window.map where clicked:
    //       console.log("oiiiiii");
    // window.map.on('mousemove', 'polygon', function(e) {
    //     // Change the cursor style as a UI indicator.
    //   console.log(e);
    // });

    window.map.on('mouseenter', 'polygon', function(e) {
        // Change the cursor style as a UI indicator.
      console.log("entered");
      window.StopClick = true;
      console.log(window.StopClick);
    });

    window.map.on('mouseleave', 'polygon', function(e) {
        // Change the cursor style as a UI indicator.
      console.log("left");
            window.StopClick = false;
      console.log(window.StopClick);
    });

     window.map.on('click', function(e) {
// Move:
    //  const place = { lng: e.lngLat.lng, lat: e.lngLat.lat};
    //  addCircleToMarker(window.map,place);
    //  window.map.panTo([e.lngLat.lng, e.lngLat.lat]);
// x
      if(window.StopClick) {
        return;
      }
      //console.log([e.lngLat.lng, e.lngLat.lat]);

      const myData =`lng=${e.lngLat.lng}&lat=${e.lngLat.lat}`;
      //const myData = {lat:21, lng: 30};

      Rails.ajax({
                type: "GET",
                url: "/pitches_map",
                data: myData,
                contentType: "application/json",
                dataType: 'script',
              success: function (form) {
                //console.log("successs");
              }
       });
    });
  }
};

function onSuccess(result) {
  //console.log(result.Response.View[0].Result[0]);
};


const removeOldMarkers = () => {
  if (typeof window.oldmarkers !== 'undefined'){
    //console.log(window.oldmarkers);
        console.log("removing old markers")
        window.oldmarkers.forEach((marker) => {
        //if (marker.home) {
          marker.remove();
        //  console.log("remmmm")
        //} else {
          //marker.remove();
        //  console.log("skippppp")
       // }
      });


   }

};

window.addMarkersAfterClick = (map,markers) => {
  console.log(map.getStyle().layers);
  //map.clear();
  //map.removeAnnotations();
  // map.removeAllAnnotations();
  //map.removeLayer('marker').removeSource('marker');
  //removeOldMarkers();

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

