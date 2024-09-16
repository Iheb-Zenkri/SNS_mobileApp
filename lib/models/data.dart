import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sns_app/models/Client.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/Worker.dart';

class ApiService {
  final String _baseUrl = 'http://localhost:3000/api';

//////////////////////////////////////////////////
//////////// Service Data Management ////////////
////////////////////////////////////////////////

//// get all Services
  Future<List<Service>> fetchAllServices() async {
    final url = Uri.parse('$_baseUrl/allServices');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {

        final body = jsonDecode(response.body);
        return (body as List).map((json) => Service.fromJson(json as Map<String, dynamic>)).toList();

      } else {
        throw Exception('Failed to load services, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

//// get service by id methode
  Future<Service> fetchServiceById(int id) async {
  final url = Uri.parse('$_baseUrl/service/$id');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Service.fromJson(body as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load service, status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to connect to the server: $e');
  }
}

//// get service by date methode
Future<List<Service>> fetchServiceByDate(String date) async {
  final url = Uri.parse('$_baseUrl/services/$date');
  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return (body as List)
          .map((json) => Service.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    return [];
  }
}


//// get numbre of service in a month 
Future<List<int>> fetchServiceCountByMonth(String date) async {
  final url = Uri.parse('$_baseUrl/nbServices/$date');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final totalService = body['totalService'] as int;
      final unfinishedService = body['unfinishedService'] as int;

      // Return both values as a list of integers
      return [totalService, unfinishedService];
    } else {
      return [0, 0];
    }
  } catch (e) {
    return [0, 0] ;
  }
}

//// post service methode
  Future<http.Response> createService(Service service) async {
      final url = Uri.parse('$_baseUrl/addService');
      
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(service.toJson()),
        );
        return response ;
        
      } catch (e) {
        throw Exception('Failed to connect to the server: $e');
      }
    }

//// update service methode
  Future<http.Response> updateService(Service service) async {
    final url = Uri.parse('$_baseUrl/updateService/${service.id}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(service.toJson()),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

//// delete service methode
Future<http.Response> deleteService(int serviceId) async {
  final url = Uri.parse('$_baseUrl/deleteService/$serviceId');
  try {
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  } catch (e) {
    throw Exception('Failed to delete service: $e');
  }
}

//////////////////////////////////////////////////
//////////// Client Data management //////////////
//////////////////////////////////////////////////

/// get all clients methode
  Future<List<Client>> fetchAllClients() async {
    final url = Uri.parse('$_baseUrl/AllClients');
    try{
      final response = await http.get(url);

      if(response.statusCode == 200){
        final body = jsonDecode(response.body);
        return (body as List).map((json) => Client.fromJson(json)).toList() ;
      } else {
        return [] ;
      }
    } catch (e) {
      return [];
    }
  }
///
/// post client methode
  Future<http.Response> createClient(Client client) async {
      final url =  Uri.parse('$_baseUrl/addClient');
      try{
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(client.toJson()),
        );
        return response ;
      }catch(e){
        throw Exception('Failed to connect to the server: $e');
      }
  
  }

/// update client methode
  Future<http.Response> updateClient(Client client) async {
  final url = Uri.parse('$_baseUrl/updateClient/${client.id}');
  try {
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    return response;
  } catch (e) {
    throw Exception('Failed to connect to the server: $e');
  }
}


//////////////////////////////////////////////////
//////////// Worker Data management //////////////
//////////////////////////////////////////////////

///get all workers methode
  Future<List<Worker>> fetchAllWorkers()async {
    final url = Uri.parse('$_baseUrl/allWorkers');
    try{
      final response = await http.get(url);
      if(response.statusCode == 200 || response.statusCode == 201){
        final body = jsonDecode(response.body);
        return (body as List).map((json)=> Worker.fromJson(json)).toList() ;
      }else{
        return [];
      }
    }catch(e){
      return [];
    }
  }

///post worker methode
  Future<http.Response> createWorker(Worker worker) async {
    final url =  Uri.parse('$_baseUrl/addWorker');
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(worker.toJson()),
      );
      return response ;
    }catch(e){
      throw Exception('Failed to connect to the server: $e');
    }
  }

/// update worker methode
  Future<http.Response> updateWorker(Worker worker) async {
  final url = Uri.parse('$_baseUrl/updateWorker/${worker.id}');
  try {
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(worker.toJson()),
    );
    return response;
  } catch (e) {
    throw Exception('Failed to connect to the server: $e');
  }
}

//// delete service methode
Future<http.Response> softDeleteWorker(int workerId) async {
  final url = Uri.parse('$_baseUrl/softDeleteWorker/$workerId');
  try {
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  } catch (e) {
    throw Exception('Failed to delete service: $e');
  }
}


//////////////////////////////////////////////////
////////// Equipement Data management ////////////
//////////////////////////////////////////////////

/// get all equipements
  Future<List<dynamic>> getAllEquipments() async {
    final response = await http.get(Uri.parse('$_baseUrl/equipements'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      return jsonDecode(response.body);
    } else {
      return [] ;
    }
  }

/// get equipement image by id
  Future<String> getEquipmentImage(int id) async {
  final response = await http.get(Uri.parse('$_baseUrl/equipment/$id/image'));

  if (response.statusCode == 200) {
    return '$_baseUrl/equipment/$id/image';  
  } else {
    return '';
  }
}

///post equipement methode
  Future<http.Response> createEquipement(dynamic equipement) async {
    final url =  Uri.parse('$_baseUrl/equipement');
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(equipement),
      );
      return response ;
    }catch(e){
      throw Exception('Failed to connect to the server: $e');
    }
  }

///post equipement image mthode
   Future<http.StreamedResponse> uploadEquipementImage(int id, File? selectedImage) async {
    print(id);
    final url = Uri.parse('$_baseUrl/equipement/$id/image');
    try{
      var request = http.MultipartRequest('POST', url);
      request.fields['title'] = "Static title" ;
      if(selectedImage != null){
        request.files.add(http.MultipartFile(
          'image',
          selectedImage.readAsBytes().asStream(),
          await selectedImage.length(),
          filename: selectedImage.path.split('/').last,
        ));
      }

      final response = await request.send();
       return response ;
    }catch(e){
      print('Exception : $e ');
      throw Exception('Failed to connect to the server: $e');
    }
  }

//// delete service methode
Future<http.Response> deleteEquipement(int equipementId) async {
  final url = Uri.parse('$_baseUrl/equipement/$equipementId');
  try {
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  } catch (e) {
    throw Exception('Failed to delete service: $e');
  }
}


}
