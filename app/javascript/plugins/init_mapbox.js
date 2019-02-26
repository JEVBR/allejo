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

const addMarkersToMap = (map, markers) => {
  markers.forEach((marker) => {
    console.log(marker)
    if (marker.home) {
      const popup = addPopUps(marker)
      new mapboxgl.Marker()
        .setLngLat([ marker.lng, marker.lat ])
        .setPopup(popup)
        .addTo(map);
      map.flyTo({ center: [ marker.lng, marker.lat ] });
    } else{
      new mapboxgl.Marker({color: 'red'})
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);
      map.flyTo({ center: [ marker.lng, marker.lat ] });
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
    const markers = JSON.parse(mapElement.dataset.markers);
    addMarkersToMap(map, markers);

    map.addLayer({
      "id": "circle500",
      "type": "circle",
      "source": "source_circle_500",
      "layout": {
        "visibility": "none"
      },
      "paint": {
        "circle-radius": 804672,
        "circle-color": "#5b94c6",
        "circle-opacity": 0.6
      }
    });
  }
};

export { initMapbox };


// import mapboxgl from 'mapbox-gl';

// const mapElement = document.getElementById('map');

// const buildMap = () => {
//   mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
//   return new mapboxgl.Map({
//     container: 'map',
//     style: 'mapbox://styles/mapbox/streets-v10'
//   });
// };

// const addMarkersToMap = (map, markers) => {
//   markers.forEach((marker) => {
//     new mapboxgl.Marker()
//       .setLngLat([ marker.lng, marker.lat ])
//       .addTo(map);
//   });
// };

// const fitMapToMarkers = (map, markers) => {
//   const bounds = new mapboxgl.LngLatBounds();
//   markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
//   map.fitBounds(bounds, { padding: 70, maxZoom: 15 });
// };

// const initMapbox = () => {
//   if (mapElement) {
//     const map = buildMap();
//     const markers = JSON.parse(mapElement.dataset.markers);
//     addMarkersToMap(map, markers);
//     fitMapToMarkers(map, markers);
//   }
// };

// export { initMapbox };
