import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sns_app/models/Client.dart';

class Location {
  List<double> coordinates;

  Location({
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      coordinates: List<double>.from(json['coordinates']),
    );
  }
  
///// This code is written for dealing with the town Names 
////  in specifique Area 

 Future<String> getLocationName() async {
    final url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=${coordinates.first}&lon=${coordinates.last}';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String name =  data['display_name'] ;
        final segments = name.split(',').map((s)=> s.trim()).toList() ;
        
        for (var segment in segments) {
          if (_isValidSegment(segment)) {
            return segment;
          }
        }
        return "Djerba" ;
      } else {
        return "Djerba" ;
      }
    } catch (e) {
      return "Djerba" ;
    }
  }
  bool _isValidSegment(String segment) {
  final regex = RegExp(r'^[a-zA-Z\s]+$'); 
  return segment.isNotEmpty && regex.hasMatch(segment);
}

}

class Service {
  final int id;
  String date;
  String type;
  String time;
  Location location;
  int nbWorkers;
  bool equipment;
  double estimatedPrice;
  bool finished;
  Client client;

  Service({
    required this.id,
    required this.date,
    required this.type,
    required this.time,
    required this.location,
    required this.nbWorkers,
    required this.equipment,
    required this.estimatedPrice,
    required this.finished,
    required this.client,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      date: json['date'],
      type: json['type'],
      time: json['time'],
      location: Location.fromJson(json['location']),
      nbWorkers: json['nbWorkers'],
      equipment: json['equipment'],
      estimatedPrice:( json['estimatedPrice'] as num).toDouble(),
      finished: json['finished'],
      client: json['client'] != null
          ? Client.fromJson(json['client'])
          : Client(id: 0, name: '', phoneNumber: '', isDeleted: false),
    );

  }

   Map<String, dynamic> toJson() {
    return {
      'date': date,
      'type': type,
      'time': time,
      'location': {
        'type': 'Point',
        'coordinates': location.coordinates,
      },
      'nbWorkers': nbWorkers,
      'equipment': equipment,
      'estimatedPrice': estimatedPrice,
      'finished': finished,
      'clientId': client.id
    };
  }
}
