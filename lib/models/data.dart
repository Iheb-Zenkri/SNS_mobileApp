import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;  
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sns_app/models/Client.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/User.dart';
import 'package:sns_app/models/Worker.dart';
import 'package:sns_app/models/Notification.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.1.79:3000/api' ; 
//////////////////////////////////////////////////
///////////// User Data Management //////////////
////////////////////////////////////////////////

Future<http.Response> loginUser(String username, String password) async {
    final url = Uri.parse('$_baseUrl/loginUser');
    try {
      final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username' : username,
            'password' : password
          }),
        );
        return response ;
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

Future<bool> getUserImage() async {
  final username = await User.custom().getUsername() ;
  final url = Uri.parse('$_baseUrl/getImage/${Uri.encodeComponent(username)}');
  try {
    final response = await http.get(url);
    if(response.statusCode == 200){
      final directory = await getApplicationDocumentsDirectory();
      final imageDirectory = Directory(p.join(directory.path, 'icons'));

       if (!await imageDirectory.exists()) {
            await imageDirectory.create(recursive: true);
      }
      final imageName = await User.custom().getPicName() ;
      final imagePath = p.join(imageDirectory.path, imageName);
      print(imagePath);
      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(response.bodyBytes);
    }
    return true ;
  } catch (e) {
      throw Exception('Failed to connect to the server: $e');  }
}

Future<User> getUser(int userId) async {
    final url = Uri.parse('$_baseUrl/user/$userId');
    try {
      final response = await http.get(url);

      if(response.statusCode == 200){
        final body = jsonDecode(response.body);
        return User.fromJson(body) ;
      }
      else{
        return User.custom() ;
      }
    } catch (e) {
      return User.custom() ;
    }

}

//////////////////////////////////////////////////
//////////// Service Data Management ////////////
////////////////////////////////////////////////


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
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final int? userId = sharedPreferences.getInt('id');
      final url = Uri.parse('$_baseUrl/$userId/addService');
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
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url = Uri.parse('$_baseUrl/$userId/updateService/${service.id}');
    
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
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final int? userId = sharedPreferences.getInt('id');
  final url = Uri.parse('$_baseUrl/$userId/deleteService/$serviceId');
  
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

//// delete client's services methode
  Future<http.Response> deleteClientServices(int clientId) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url = Uri.parse('$_baseUrl/$userId/deleteClientServices/$clientId'); 
    
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
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final int? userId = sharedPreferences.getInt('id');
      final url =  Uri.parse('$_baseUrl/$userId/addClient');
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
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final int? userId = sharedPreferences.getInt('id');
  final url = Uri.parse('$_baseUrl/$userId/updateClient/${client.id}');
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
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url = Uri.parse('$_baseUrl/$userId/deleteClient/$clientId');
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
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url = Uri.parse('$_baseUrl/$userId/permanentlyDeleteClient/$clientId');
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
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url =  Uri.parse('$_baseUrl/$userId/addWorker');
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
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final int? userId = sharedPreferences.getInt('id');
  final url = Uri.parse('$_baseUrl/$userId/updateWorker/${worker.id}');
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
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final int? userId = sharedPreferences.getInt('id');
  final url = Uri.parse('$_baseUrl/$userId/softDeleteWorker/$workerId');
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
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final int? userId = sharedPreferences.getInt('id');
  final url = Uri.parse('$_baseUrl/$userId/permanentlyDeleteWorker/$workerId');
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
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      final int? userId = sharedPreferences.getInt('id');
      final url = Uri.parse('$_baseUrl/$userId/addWorker/$serviceId');
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

/// delete worker from service methode
  Future<http.Response> deleteWorkerFromService(int serviceId,int workerId) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url = Uri.parse('$_baseUrl/$userId/service/$serviceId/worker/$workerId');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      return response ;
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

//////////////////////////////////////////////////
/////////// Notifications management /////////////
//////////////////////////////////////////////////

//// get newer 10 Notifications 
  Future<List<Notifications>> getNewerNotifications(int lastId) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url = Uri.parse('$_baseUrl/$userId/newNotifications/$lastId');
    try {
      final response = await http.get(url);
      if(response.statusCode == 200){
        final body = jsonDecode(response.body);
        final result = body.map<Notifications>((json) => Notifications.fromJson(json)).toList();
        return result ;
      }
      else{
        return [] ;
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
    
  }
  
//// get older 10 Notifications 
  Future<List<Notifications>> getolderNotifications(int lastId) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url = Uri.parse('$_baseUrl/$userId/oldNotifications/$lastId');
    try {
      final response = await http.get(url);
      if(response.statusCode == 200){
        final body = jsonDecode(response.body);
        final result = body.map<Notifications>((json) => Notifications.fromJson(json)).toList();
        return result ;
      }
      else{
        return [] ;
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
    
  }

  //// mark notification as read 
  Future<void> markNotificationsAsRead(int lastId) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int? userId = sharedPreferences.getInt('id');
    final url = Uri.parse('$_baseUrl/$userId/markAsRead/$lastId');
    try {
      await http.put(url);
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
