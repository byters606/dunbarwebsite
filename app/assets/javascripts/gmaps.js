var map;
function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: 4.258860, lng: 24.293072},
    zoom: 1,
    mapTypeControl: false,
    zoomControl: true,
    zoomControlOptions: {
        position: google.maps.ControlPosition.RIGHT_CENTER
    },
    scaleControl: true,
    streetViewControl: false
  });
}

$(document).ready(function() {
  if (gon.members != undefined) {
    for (i = 0; i < gon.members.length; i++) { 
      var geocoder = new google.maps.Geocoder();
      geocoder.geocode({'address': gon.members[i].birthplace},
        function(results, status) {
          if (status === 'OK') {
            var marker = new google.maps.Marker({
              map: map,
              position: results[0].geometry.location
            });
          }
        }
      );
    }  
  }
});