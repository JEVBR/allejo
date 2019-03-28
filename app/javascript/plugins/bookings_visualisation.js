const init_visualisation_poller = () => {
  // Verify if this element exists on the page, the id "Keep_Owner_Updated" should be somewhere on the HTML page:
  const ownerPannelElement = document.getElementById('Keep_Owner_Updated');
  // Setup a regular request when on the correct page:
  if (ownerPannelElement) { setInterval(request_owner_update, 5000);}
};

// kindly ask for update on bookings:
const request_owner_update = () => {
  Rails.ajax({
            type: "GET",
            url: "/users_owner_update",
            data: "Are there any new bookings on my pitch",
            contentType: "application/json",
            dataType: 'script',
          success: function (form) {
            //console.log("succes");
          }
  });
};

export { init_visualisation_poller };
