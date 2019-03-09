// app/javascript/plugins/init_autocomplete.js
import places from 'places.js';

const initAutocomplete = () => {
  const addressInput = document.getElementById('location');
  if (addressInput) {
    places({ container: addressInput, style:false });
  }
  const addressInputNewUser = document.getElementById('user_address');
  if (addressInputNewUser) {
    places({ container: addressInputNewUser });
  }
};

export { initAutocomplete };
