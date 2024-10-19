import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationPage extends StatefulWidget {
  
  const LocationPage({super.key});
  @override
  State<LocationPage> createState() => _LocationPageState() ;
}

class _LocationPageState extends State<LocationPage> {
  
  MapController mapController = MapController();

  List<String> types = ['Tout','fin chantier', 'menage','gardin', 'autre'] ;
  
  String? _typeController = 'Tout' ;
  String dateController = DateFormat('yyyy-MM-dd').format(DateTime.now());

////Search variables
  List<Service> filteredServices = [];
  String searchQuery = '';

  LatLng selectedLocation = LatLng(33.8020,10.8842325);
  LatLng currentLocation = LatLng(33.8020447,10.8520494);
  final ScrollController _scrollController = ScrollController();

  late Future<List<Service>> futureService ;


@override
  void initState() {
    super.initState();
    getDatabyDay(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    //_trackLocation();
  }

@override
  void dispose(){
    _scrollController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        slivers: <Widget> [
          SliverAppBar(
            pinned: true,
            stretch: false,
            expandedHeight: MediaQuery.sizeOf(context).height-100,
            backgroundColor: Colors.white,
            elevation: 0.0,
            actions: [
              Container(
                margin: EdgeInsets.only(right: 10.0,top: 10.0),
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                width: 100,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: GestureDetector(
                  onTap: (){
                    _openGoogleMapsWithMarkers(currentLocation,selectedLocation);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text("SUIVRE",style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            color: informationColor,
                          ),),
                          Text("ROUTE",style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                            color: neutralColor100,
                          ),),
                        ],
                      ),
                      Image.asset('lib/icons/google-maps.png',height: 30,width: 30,),
                    ],
                  ),
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: FutureBuilder<List<Service>>(
                  future: futureService,
                  builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final service = snapshot.data! ;
                  return FlutterMap(
                    mapController: mapController,
                          options: MapOptions(
                            minZoom: 10,
                            maxZoom: 16,
                            initialZoom: 12.5,
                            initialCenter: currentLocation,
                            interactionOptions: InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
                          ),
                          
                          children:[
                            openStreetMapTileLayer,
                            MarkerLayer(markers: [
                            Marker(
                              point: currentLocation, 
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(Icons.location_pin,color: Colors.blueGrey, size: 50,),
                                    Positioned(
                                      top: 7,
                                      left: 12.5,
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: ClipOval(child:Image.asset('lib/icons/userpic.jpg'),)
                                      )
                                    ),
                                  ],
                                ),
                              )
                            ),
                            ...service.map((service)=>Marker(
                               height: 100,
                                width: 150,
                                alignment: Alignment.center,
                                point: fromLocation(service), 
                                child: GestureDetector(
                                  onDoubleTap: (){
                                    mapController.move(fromLocation(service), 15.0);
                                  },
                                  onTap: (){
                                    setState(() {
                                      selectedLocation = fromLocation(service);
                                    });
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    alignment: Alignment.center,
                                    children: [
                                      if (selectedLocation == fromLocation(service))
                                      Positioned(
                                        top: 0,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: getServiceColor(service).withOpacity(0.6),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              service.client.name,
                                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      Icon(Icons.location_pin,color: getServiceColor(service), size: 40,),
                                    ],
                                  )
                                  )
                                )
                              ),
                            ])
                          ]);
                  },
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: Container(
                height: 80,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 40,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: colorFromHSV(220, 0.12, 1.0),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                     TextField(
                      onTap: (){
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              500, 
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          });
                        },
                        onChanged: (value){
                          setState(() {
                            searchQuery = value ;
                          });
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorFromHSV(220, 0.06, 1.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none,
                            gapPadding: 0,
                          ),
                          hintText: "Chercher un Service",
                          hintStyle: TextStyle(
                            fontSize: 12,
                            letterSpacing: 2.0,
                            color: neutralColor200,
                            fontWeight: FontWeight.w600,
                            ),
                          prefixIcon:  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorFromHSV(220, 0.12, 1.0) ,
                                borderRadius: BorderRadius.circular(50.0)
                              ),
                              child: Icon(Iconsax.search_normal_14,size: 18,)),
                          ),
                          prefixIconColor: informationColor,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.5,
                          color: informationColor700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 500,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                            final DateTime? dateTime = await showDatePicker(
                              context: context, 
                              firstDate: DateTime(2024,10,1), 
                              lastDate: DateTime.now().add(Duration(days: 365)),
                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                              builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.light().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: informationColor, // Header background color
                                    onPrimary: Colors.white, // Header text color
                                    onSurface: informationColor600, // Body text color
                                  ),
                                  dialogBackgroundColor: Colors.white, // Background color of the picker
                                ),
                                child: child!,
                              );
                            },
                              );
                              if(dateTime != null){
                                setState(() {
                                  dateController = DateFormat('yyyy-MM-dd').format(dateTime);
                                  getDatabyDay(dateController);
                                });
                              }
                        },
                      child: Container(
                        width: 150,
                        height: 50,
                        padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color:informationColor300,width: 1,),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(dateController),
                            Icon(Iconsax.calendar_add,size: 20,color: informationColor,),
                            ],
                          )
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        width: 150,                
                        child:DropdownButtonFormField<String>(
                                value: _typeController,
                                decoration: InputDecoration(
                                  labelText: " Type ",
                                  labelStyle: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1.5,
                                    color: neutralColor200,
                                    fontWeight: FontWeight.bold
                                  ),                        
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: informationColor300,width: 1,),
                                    gapPadding: 0,
                                  ),
                                  focusedBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(color: informationColor300,width: 1,),
                                    gapPadding: 0,
                                  ),
                                ),
                                isExpanded: true,
                                icon: Icon(Iconsax.arrow_down_1,size: 18,color: informationColor,),
                                isDense: false,
                                selectedItemBuilder: (BuildContext context) {
                                  return types.map<Widget>((String value) {
                                    return Center(
                                      child: Text(value,style: TextStyle(
                                        fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: neutralColor,
                                          letterSpacing: 2.0,
                                      ),),
                                    );
                                  }).toList();
                                },
                                items: types.map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: neutralColor,
                                          letterSpacing: 2.0,
                                        ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _typeController = newValue ;
                                  });
                                },
                                menuMaxHeight: 150,   
                              ),
                      ),
                    ],
                  ),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
                      child: FutureBuilder<List<Service>>(
                        future: futureService, 
                        builder: (context, snapshot){
                          ////handling serveur delay or issue
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: Le serveur est en panne !!'));
                          } else if(snapshot.hasData){
                          //// filtre services by date and display it
                            List<Service> allServices = snapshot.data!;
                              filteredServices = allServices.where((service) {
                                final matchesType = _typeController == 'Tout'  || service.type == _typeController;
                                final matchesQuery = searchQuery.isNotEmpty ? service.client.name.toLowerCase().contains(searchQuery.toLowerCase()) : true ;
                                return matchesType && matchesQuery;
                              }).toList();
                            filteredServices.sort((a, b) => a.time.compareTo(b.time));
                            return ListView.builder(
                            itemCount:  filteredServices.isEmpty ? 1 :filteredServices.length,
                            itemBuilder:(context, index) {
                              return filteredServices.isEmpty ? 
                                      SizedBox(
                                        height: 300, 
                                        child: 
                                        Center(
                                          child: 
                                          Text('Aucun service pour $dateController' )
                                        )) : GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              selectedLocation = fromLocation(filteredServices[index]);
                                            });
                                            WidgetsBinding.instance.addPostFrameCallback((_) {
                                              _scrollController.animateTo(
                                                0.0, // Scroll to the bottom or specific position
                                                duration: Duration(milliseconds: 300),
                                                curve: Curves.easeInOut,
                                              );
                                            });
                                            mapController.move(selectedLocation, 12);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),                                        
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 25,
                                                  width: 25,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: getServiceColor(filteredServices[index]),
                                                    borderRadius:BorderRadius.circular(50.0),
                                                  ),
                                                  child: Text(filteredServices[index].type.substring(0,1).toUpperCase(),style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),),
                                                ),
                                                SizedBox(width: 20,),
                                                Text(filteredServices[index].client.name,style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: neutralColor300
                                                ),),
                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Icon(Iconsax.profile_2user5,color: getServiceColor(filteredServices[index]).withOpacity(0.5),size: 16,),
                                                    Text(' ${filteredServices[index].nbWorkers}',style: TextStyle(
                                                      color: getServiceColor(filteredServices[index]).withOpacity(0.6),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold
                                                    ),)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      
                            },
                            );
                          }else {
                            return Center(child: Text('No services available.'));
                          }
                        }),
                    )
                  
                  )
                ],
              ),
            )
          )
        ],
      )
    );
  }

  TileLayer get openStreetMapTileLayer => TileLayer(
    tileProvider: CancellableNetworkTileProvider(),
    urlTemplate: "https://tile.thunderforest.com/atlas/{z}/{x}/{y}.png?apikey=40f66bfbe81e4b4f9707991ad79b731d",
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );
  
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

 void _trackLocation() async {
       try {
      Position position = await _determinePosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        mapController.move(currentLocation, 15.0);
      });
    } catch (e) {
      return ;
    }
  }

 void _openGoogleMapsWithMarkers(LatLng first,LatLng last) async {

    final origin = '${first.latitude},${first.longitude}';
    final destination = '${last.latitude},${last.longitude}';
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/dir/',
      query: 'api=1&origin=$origin&destination=$destination',
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not open Google Maps.';
    }
  }
  
  void getDatabyDay(String date){
      setState(() {
        futureService = ApiService().fetchServiceByDate(date);
    });
  }

  LatLng fromLocation(Service service){
    return LatLng(service.location.coordinates.first, service.location.coordinates.last);
  }
 
 Color getServiceColor(Service service){
    switch(service.type){
      case 'fin chantier' :
        return informationColor;
      case 'gardin' :
        return successColor ;
      case 'menage' :
        return alertColor ;
      default :
        return primaryColor ;
    }
 }

}

