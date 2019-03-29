import "bootstrap";

import 'mapbox-gl/dist/mapbox-gl.css'; // <-- you need to uncomment the stylesheet_pack_tag in the layout!
import { initMapbox } from '../plugins/init_mapbox';
import { initAutocomplete } from '../plugins/init_autocomplete'
import { init_visualisation_poller } from '../plugins/bookings_visualisation'

initMapbox();
initAutocomplete();
init_visualisation_poller();
