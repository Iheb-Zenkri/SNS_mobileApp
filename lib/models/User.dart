import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  String username;
  String phoneNumber;
  String? password;
  String? picName ;

  User.custom()
      : id = 0,
        username = '',
        phoneNumber = '',
        password = null,
        picName = null;

  User({
    required this.id,
    required this.username,
    required this.phoneNumber,
    this.password,
    this.picName,
  });

   factory User.fromJson(Map<String, dynamic> json) {
      return User(
        id: json['id'], 
        username: json['username'], 
        phoneNumber: json['phoneNumber'] ,
        picName : json['picName'],
        password: json['password'],
      );
   }

   Map<String, dynamic> toJson() {
    return {
      'username' : username,
      'phoneNumber' : phoneNumber,
      'picName' : picName,
      'password' : password
    };
   }

   Future savePrefrences() async{
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("username", username);
      await sharedPreferences.setString("phoneNumber", phoneNumber);
      await sharedPreferences.setInt("id", id);
      await sharedPreferences.setString("password", password!);
      await sharedPreferences.setString("picName", picName!);
      //ApiService().getUserImage();
   }

  Future<String> getUsername() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return  sharedPreferences.getString("username")??"";
  }

  Future<String> getPhoneNumber() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return  sharedPreferences.getString("phoneNumber")??"";
  }

  Future<String> getPicName() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return  sharedPreferences.getString("picName")??"";
  }


}