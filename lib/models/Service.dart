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
  int nbDays;
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
    required this.nbDays,
    required this.equipment,
    required this.estimatedPrice,
    required this.finished,
    required this.client,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      type: json['type']as String? ?? '',
      time: json['time']as String? ?? '',
      location: Location.fromJson(json['location']),
      nbWorkers: json['nbWorkers']as int? ?? 1,
      nbDays: json['nbDays']as int? ?? 1,
      equipment: json['equipment'] as bool? ?? false,
      estimatedPrice: json['estimatedPrice'] as double? ?? 0.0,
      finished: json['finished'] as bool? ?? false,
      client: json['client'] !=null ? Client.fromJson(json['client']) : Client(id: 0, name: '', phoneNumber: '') ,
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
      'nbDays': nbDays,
      'equipment': equipment,
      'estimatedPrice': estimatedPrice,
      'finished': finished,
      'clientId': client.id
    };
  }
}
