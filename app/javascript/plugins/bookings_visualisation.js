const init_visualisation_poller = () => {
  // Verify if this element exists on the page, the id "Keep_Owner_Updated" should be somewhere on the HTML page:
  const ownerPannelElement = document.getElementById('Keep_Owner_Updated');
  // Setup a regular request when on the correct page:
  if (ownerPannelElement) { setInterval(request_owner_update, 5000);}
};

// kindly ask for update on bookings:
const request_owner_update = () => {
  const current_user_id = document.getElementById('current_pitch_id');
  const first_date  = document.getElementById('current_first_date');
  const myData = `pitch_id=${current_pitch_id.innerHTML}&date=${first_date.innerHTML}`;
  Rails.ajax({
            type: "GET",
            url: "/users_owner_update",
            data: myData,
            contentType: "application/json",
            dataType: 'script',
          success: function (form) {
            //console.log("succes");
          }
  });
};

export { init_visualisation_poller };
