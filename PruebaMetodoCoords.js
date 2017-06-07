function degreesToRadians(degrees) {
  return degrees * Math.PI / 180;
}

function distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
  var earthRadiusKm = 6371;

  var dLat = degreesToRadians(lat2-lat1).toFixed(10);
  console.log(dLat);
  var dLon = degreesToRadians(lon2-lon1).toFixed(10);
  console.log(dLon);
  lat1 = degreesToRadians(lat1).toFixed(10);
  lat2 = degreesToRadians(lat2).toFixed(10);
  console.log(lat1);
  console.log(lat2);
  var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2);
  console.log(a); 
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  return earthRadiusKm * c;
}

console.log("Distancia en KM: " + distanceInKmBetweenEarthCoordinates(9.9721549,-84.1283363, 9.9983516,-84.139515));