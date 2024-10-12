import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sns_app/models/Client.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/Worker.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.1.79:3000/api' ; //'http://localhost:3000/api';

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

    if (response.statusCode == 200){
      final body = jsonDecode(response.body);
      final testBody = (body as List).map((json) => Service.fromJson(json)).toList();
      return testBody ;
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

/// get all deleted clients methode
Future<List<Client>> fetchAllDeletedClients() async {
    final url = Uri.parse('$_baseUrl/AllDeletedClients');
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

/// get service count for clients methode
Future<int> getNbServiceForClient(int clientId) async{
    final url = Uri.parse('$_baseUrl/ClientsServiceCount/$clientId');
    try {
      final response = await http.get(url);

      if(response.statusCode == 200){
        return jsonDecode(response.body);
      }
      else{
        return 0;
      }
    } catch (e) {
      return 0 ;
    }
}

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

/// soft delete client methode
  Future<http.Response> softDeleteClient(int clientId) async {
    final url = Uri.parse('$_baseUrl/deleteClient/$clientId');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to soft delete service: $e');
    }
  }

/// permanently delete client methode
  Future<http.Response> permanentlyDeleteClient(int clientId) async {
    final url = Uri.parse('$_baseUrl/permanentlyDeleteClient/$clientId');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to permantly delete service: $e');
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

/// get all availble workers for a custom date
  Future<List<Worker>> fetchWorkersByDate(String date)async {
    final url = Uri.parse('$_baseUrl/availbleWorkers/$date');
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

//// Soft delete worker methode
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

//// Permantly delete worker methode
Future<http.Response> deleteWorker(int workerId) async {
  final url = Uri.parse('$_baseUrl/permanentlyDeleteWorker/$workerId');
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
//////// Service'worker Data management //////////
//////////////////////////////////////////////////

//// get workers of servcie
Future <List<Worker>> getServiceWorker(int id) async {
  final response = await http.get(Uri.parse('$_baseUrl/service/$id/workers'));

  if (response.statusCode == 200) {
    final workerJsonMap = jsonDecode(response.body);

    final result = workerJsonMap.map<Worker>((json) => Worker.fromJson(json)).toList();
    
    return result;
  } else {
    return [];
  }
}

//// affect a worker to a service
  Future<http.Response> addWorkerToService(int serviceId,int workerId,String startDate) async{
    final url = Uri.parse('$_baseUrl/addWorker/$serviceId');
    try {
      final workerService = {
        "workerId": workerId,
        "startDate": startDate
      };
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(workerService),
      );
      return response ;
    } catch (e) {
        throw Exception('Failed to connect to the server: $e');
    }
  }
}
