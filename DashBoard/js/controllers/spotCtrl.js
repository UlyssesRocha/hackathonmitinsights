/*global todomvc, angular, Firebase */
'use strict';

/**
 * The main controller for the app. The controller:
 * - retrieves and persists the model via the $firebase service
 * - exposes the model to the template and provides event handlers
 */
larperfeito.controller('SpotCtrl', function SpotCtrl($scope, $location, $firebase,$http,$interval) {
	var url = 'https://zona-azul-dd7a0.firebaseio.com/spots';
	var fireRef = new Firebase(url);
	//console.log(fireRef);

	var icons = {
    em_uso:'http://maps.google.com/mapfiles/ms/icons/orange-dot.png',
    livre:'http://maps.google.com/mapfiles/ms/icons/green-dot.png',
    nao_identificado: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png',
    irregular: 'http://maps.google.com/mapfiles/ms/icons/red-dot.png'
}





//Markers
				    var markers = new GMaps({
				        div: '#gmap_markers',
				        lat: -22.905592,
				        lng: -47.062576
				    });

				    var noPoi = [
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "poi",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "transit",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  }
];

					markers.setOptions({styles: noPoi});




	$scope.$watch('spots', function () {

		var total = 0;
		var remaining = 0;
		var available = 0;
		var notavailable = 0;
		var nochip = 0;



		var markers_clean = markers.markers;
		for(var i = 0; i < markers_clean.length; i++) {
		    markers_clean[i].setMap(null);
		}






		
	
			//console.log(spots);





			var icon;

			//angular.forEach($scope.spots, function (row,key) {
			$scope.spots.$getIndex().forEach(function (index) {
				console.log(index);
				console.log($scope.spots);
				var row = $scope.spots[index];
				//$scope.spots[index].completed = !allCompleted;
				
				if(!row){
					return false;
				}
				
				if(row.vehicle && row.vehicle !== 'true' && row.vehicle !== 'false'  ){

					notavailable++
					icon = icons.em_uso;
				
				}else if(row.vehicle == 'true'){

					nochip++;
					icon = icons.nao_identificado;

				}else{

					available++;
					icon = icons.livre;
				}





				   // console.log(row.lat);
				    //console.log(row.lng);
				    //console.log(row);






			});





	
		
		$scope.spot_total_notavailable = notavailable;
		$scope.spot_total_nochip = nochip;
		$scope.spot_total_available = available;

		$scope.totalCount = total;
		$scope.remainingCount = remaining;
		$scope.completedCount = total - remaining;
		$scope.allChecked = remaining === 0;
	}, true);


	// Bind the spots to the firebase provider.
	$scope.spots = $firebase(fireRef);



$http({
  method: 'GET',
  url: 'https://mitinsightsbackend.herokuapp.com/api/all'
}).then(function successCallback(response) {

	console.log(response);
	var data = response.data;
	$scope.imoveis = response.data;
	console.log($scope.imoveis);
    // this callback will be called asynchronously
    // when the response is available
  }, function errorCallback(response) {
    // called asynchronously if an error occurs
    // or server returns response with an error status.
  });

   $http.get('https://mitinsightsbackend.herokuapp.com/api/ulysses/interest').then(function(res){
        $scope.interest = res.data.interest;
    });

    $interval(function(){
        $http.get('https://mitinsightsbackend.herokuapp.com/api/ulysses/interest').then(function(res){
            $scope.interest = res.data.interest;
        });
    }, 500);


    	

	//console.log($scope.spots);



});
