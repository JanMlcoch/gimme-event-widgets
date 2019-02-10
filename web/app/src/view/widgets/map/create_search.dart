part of view;

void createSearchBox(g_m.GMap map){
  InputElement input = new InputElement();
  var searchBox = new g_m_p.SearchBox(input);
  map.controls[g_m.ControlPosition.TOP_RIGHT].push(input);
  map.onBoundsChanged.listen((_) {
    searchBox.bounds = map.bounds;
  });
  searchBox.onPlacesChanged.listen((_){
    if(searchBox.places.isEmpty)return;

  });
//  searchBox.addListener('places_changed', function () {
//  var places = searchBox.getPlaces();
//
//  if (places.length == 0) {
//  return;
//  }
//
//  // Clear out the old markers.
//  markers.forEach(function (marker) {
//  marker.setMap(null);
//  });
//  markers = [];
//
//  // For each place, get the icon, name and location.
//  var bounds = new google.maps.LatLngBounds();
//  places.forEach(function (place) {
//  if (!place.geometry) {
//  console.log("Returned place contains no geometry");
//  return;
//  }
//  var icon = {
//  url: place.icon,
//  size: new google.maps.Size(71, 71),
//  origin: new google.maps.Point(0, 0),
//  anchor: new google.maps.Point(17, 34),
//  scaledSize: new google.maps.Size(25, 25)
//  };
//
//  // Create a marker for each place.
//  markers.push(new google.maps.Marker({
//  map: map,
//  icon: icon,
//  title: place.name,
//  position: place.geometry.location
//  }));
//
//  if (place.geometry.viewport) {
//  // Only geocodes have viewport.
//  bounds.union(place.geometry.viewport);
//  } else {
//  bounds.extend(place.geometry.location);
//  }
//  });
//  map.fitBounds(bounds);
//  });
}