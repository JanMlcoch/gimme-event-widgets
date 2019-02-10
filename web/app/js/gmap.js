var map, lat, lng, markers;
window.newPlaceMarker = null;
window.prepareCenter = null;
window.mapBounds = {};
window.placeCallback = null;

window.loadMap = function (lat, lng) {
    map = new google.maps.Map(document.getElementById("appMap"), {
        center: prepareCenter ? prepareCenter : new google.maps.LatLng(lat, lng),
        zoom: 13,
        minZoom: 4,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        disableDefaultUI: false,
        clickableIcons: false,
        backgroundColor: "white"
    });

    var input = document.createElement('input');
    var searchBox = new google.maps.places.SearchBox(input);
    map.controls[google.maps.ControlPosition.TOP_RIGHT].push(input);
    map.addListener('bounds_changed', function () {
        searchBox.setBounds(map.getBounds());
    });
    var markers = [];
    searchBox.addListener('places_changed', function () {
        var places = searchBox.getPlaces();

        if (places.length == 0) {
            return;
        }

        // Clear out the old markers.
        markers.forEach(function (marker) {
            marker.setMap(null);
        });
        markers = [];

        // For each place, get the icon, name and location.
        var bounds = new google.maps.LatLngBounds();
        places.forEach(function (place) {
            if (!place.geometry) {
                console.log("Returned place contains no geometry");
                return;
            }
            var icon = {
                url: place.icon,
                size: new google.maps.Size(71, 71),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(25, 25)
            };

            // Create a marker for each place.
            markers.push(new google.maps.Marker({
                map: map,
                icon: icon,
                title: place.name,
                position: place.geometry.location
            }));

            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
        });
        map.fitBounds(bounds);
    });


map.addListener('click', function (e) {
    if (window.placeCallback) {
        if (window.newPlaceMarker) {
            window.newPlaceMarker.setPosition(e.latLng);
        } else {
            createCreatingMarker(e.latLng);
        }
        window.placeCallback(e.latLng);
        if (window.newPlaceMarker) {
            window.newPlaceMarker.setMap(null);
            window.newPlaceMarker = null;
        }
    }
});
window._mapClickRegistered = true;
google.maps.event.addListener(map, "bounds_changed", function () {
    // send the new bounds back to your server
    window.mapBounds = map.getBounds();
});
}
;
function createCreatingMarker(latLng) {
    if (window.newPlaceMarker)return;
    var pinColor = "26FF26";
    var pinImage = new google.maps.MarkerImage("http://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|" + pinColor,
        new google.maps.Size(21, 34),
        new google.maps.Point(0, 0),
        new google.maps.Point(10, 34));
    window.newPlaceMarker = new google.maps.Marker({
        position: latLng,
        draggable: true,
        map: map,
        title: window.newPlaceLang,
        icon: pinImage
    });
    google.maps.event.addListener(window.newPlaceMarker, 'dragend', function () {
        if (window.placeCallback) {
            window.placeCallback(window.newPlaceMarker.getPosition());
        }
    });
}
window.showCreatingPlace = function (lat, lng) {
    if (!window.newPlaceMarker) {
        createCreatingMarker(new google.maps.LatLng(lat, lng));
    }
};
window.removeCreatingPlace = function () {
    if (window.newPlaceMarker) {
        window.newPlaceMarker.setMap(null);
        window.newPlaceMarker = null;
    }
};

window.registerPlaceCallback = function (callback, latitude, longitude) {
    window.placeCallback = callback;
    if (latitude && longitude) {
        var latLng = new google.maps.LatLng(latitude, longitude);
        if (window.newPlaceMarker) {
            window.newPlaceMarker.setPosition(latLng);
        } else {
            createCreatingMarker(latLng);
        }
    }
};

window.addMarker = function (lat, lng, callback, name) {
    var marker = new google.maps.Marker({
        position: new google.maps.LatLng(lat, lng),
        map: map,
        title: name
    });
    google.maps.event.addListener(marker, "click", function () {
        callback();
    });
};

window.panToEventPlace = function (lat, lng) {
    if (map == undefined) {
        prepareCenter = new google.maps.LatLng(lat, lng);
    } else {
        map.panTo(new google.maps.LatLng(lat, lng));
    }
};

$(document).ready(function () {
    $(this).mousedown(function (e) {
        if (e.which == 2) {
            e.preventDefault();
            e.stopPropagation();
        }
        return true;
    });
});