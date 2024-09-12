import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_dragmarker/flutter_map_dragmarker.dart';
import 'package:sns_app/models/colors.dart';

class LocationDetection extends StatefulWidget{
  final List<double>? location;


  const LocationDetection({super.key, this.location});

  @override
  State<LocationDetection> createState() => _LoctionDetection();

}

class _LoctionDetection extends State<LocationDetection>{

    late LatLng markerPosition ;
    MapController mapController = MapController();
    LatLng currentLocation = LatLng(33.8020447,10.8520494);

    final List<DragMarker> markers = [] ;


  @override
  void initState() {
    super.initState();
   // _trackLocation();
   if(widget.location == null){
      markerPosition = currentLocation ;
   }else{
    markerPosition = LatLng(widget.location!.first, widget.location!.last);
   }
    markers.add(
      DragMarker(
        key: GlobalKey<DragMarkerWidgetState>(),
        point: markerPosition,
        rotateMarker: true,
        size: const Size.square(50),
        builder: (_, __, ___) => const Icon(
          Icons.location_on,
          size: 50,
          color: Colors.blueGrey,
        ),
        onDragUpdate: (details, latLng) {
          setState(() {
            markerPosition = latLng ;
          });
        },
      ),
    );
  }
  
  @override 
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Stack(
            children:[
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: markerPosition ,
                  initialZoom: 12.5,
                ),
                children: [
                  openStreetMapTileLayer,
                  DragMarkers(
                    markers:markers
                  ),
                  MarkerLayer(
                    markers:[
                      Marker(
                        point: currentLocation, 
                        child:  Icon(
                            Icons.location_on,
                            size: 50,
                            color: Colors.red,
                          ),)
                  ]),
                  
                ],
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 12),
                  height: 80,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
                          offset: Offset(-1,-1), // Shadow offset (x, y)
                          blurRadius: 10, // Shadow blur radius
                          spreadRadius: 3, // How much the shadow spreads
                        ),
                      ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("CHOISIR ",style: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 2,
                          ),),
                          Text("la position du client puis",style: TextStyle(
                            color: neutralColor200,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(" CONFIRMER ",style: TextStyle(
                            color: informationColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 2,
                          ),),
                          Text("la localisation",style: TextStyle(
                            color: neutralColor200,
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                            letterSpacing: 1.5,
                          ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 20,
                left: 20,
                child:GestureDetector(
                  onTap: (){
                    Navigator.pop(context, null);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2), // Shadow color
                          offset: Offset(4, 4), // Shadow offset (x, y)
                          blurRadius: 10, // Shadow blur radius
                          spreadRadius: 3, // How much the shadow spreads
                        ),
                      ],
                    ),
                    child: Icon(Iconsax.arrow_left,size: 20,color: neutralColor600,),
                  ),
                )),
             
              Positioned(
                bottom: 100,
                right: 20,
                child:GestureDetector(
                  onTap: (){
                    Navigator.pop(context,markerPosition);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: informationColor,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
                          offset: Offset(4, 4), // Shadow offset (x, y)
                          blurRadius: 10, // Shadow blur radius
                          spreadRadius: 3, // How much the shadow spreads
                        ),
                      ],
                    ),
                    child: Icon(Iconsax.location_add4,size: 30,color: Colors.white,),
                  ),
                )),
              
              Positioned(
                bottom: 170,
                right: 20,
                child:GestureDetector(
                  onTap: (){
                    _trackLocation();
                    mapController.move(currentLocation, 13);
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
                          offset: Offset(4, 4), // Shadow offset (x, y)
                          blurRadius: 10, // Shadow blur radius
                          spreadRadius: 3, // How much the shadow spreads
                        ),
                      ],
                    ),
                    child: Icon(Icons.gps_fixed_rounded,color: alertColor,size: 25,),
                  ),
                )),
            
            ],
          ),
        );
  }
  
  TileLayer get openStreetMapTileLayer => TileLayer(
    tileProvider: CancellableNetworkTileProvider(),
    urlTemplate: "https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=40f66bfbe81e4b4f9707991ad79b731d",
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );

  void _trackLocation() async {
       try {
      Position position = await _determinePosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        markerPosition  = currentLocation ;
        mapController.move(currentLocation, 15.0);
      });
    } catch (e) {
      return ;
    }
  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, return an error.
      return Future.error('Location services are disabled.');
    }

    // Request permission to access location.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    // When permissions are granted, get the position.
    return await Geolocator.getCurrentPosition();
  }
}
