import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sns_app/models/User.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';
import 'package:sns_app/pages/landing_page.dart';

class LoginPage extends StatefulWidget{

  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();

}

class _LoginPage extends State<LoginPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>() ;

  bool isObscured = false ;
  String? checkUsername ;
  String? checckPassword ;

  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    _checkUsername();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading ? Center(child: CircularProgressIndicator(),)
        : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("CONNECTER",style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 3.0,
                color: primaryColor,
              ),),
              Center(child: Image.asset('lib/icons/background.jpg',height:280,)),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30,),
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: TextFormField(
                          controller: usernameController ,
                          keyboardType: TextInputType.name,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: "Nom d'Utilisateur",
                            labelStyle: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.5,
                              color: neutralColor200,
                              fontWeight: FontWeight.bold
                            ),
                            filled: true,
                            fillColor: colorFromHSV(220, 0.06, 1),
                            focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: informationColor,width: 1.5,),
                                  gapPadding: 2.0,
                                ),
                            enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: informationColor100,width: 1,),
                                  gapPadding: 0,
                                ),
                              focusedErrorBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: alertColor600,width: 1.5,),
                                  gapPadding: 0,
                              ),   
                              errorText: checkUsername,
                              suffixIcon: Icon(Icons.person_sharp,size: 20,color: informationColor,),                       errorStyle: TextStyle(height: 1), 
                          ),
                          style:  TextStyle(
                            fontSize: 14,
                            letterSpacing: 1.5,
                            color: primaryColor700,
                            fontWeight: FontWeight.bold,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le champ ne peut pas être vide';
                            }
                            if(!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+){0,2}$').hasMatch(value)){
                              return 'Uniquement des caractères alphabétiques';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 30,),
                      SizedBox(
                        width: 300,
                        height: 60,
                        child: TextFormField(
                          controller: passwordController ,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: isObscured,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: "Mot de passe",
                            labelStyle: TextStyle(
                              fontSize: 12,
                              letterSpacing: 1.5,
                              color: neutralColor200,
                              fontWeight: FontWeight.bold
                            ),
                            filled: true,
                            fillColor: colorFromHSV(220, 0.06, 1),
                            focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: informationColor,width: 1.5,),
                                  gapPadding: 2.0,
                                ),
                            enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(color: informationColor100,width: 1,),
                                  gapPadding: 0,
                                ),
                            focusedErrorBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(color: alertColor600,width: 1.5,),
                                  gapPadding: 0,
                              ),
                            errorText: checckPassword,
                            suffixIcon: IconButton(
                              icon: isObscured ?  Icon(Icons.visibility_off_rounded,color: informationColor300,size: 20,) : Icon(Icons.visibility_rounded,color: informationColor,size: 20,),
                              onPressed: () {
                                setState(() {
                                  isObscured = !isObscured ;
                                });
                              },
                            ),
                          ),
                          style:  TextStyle(
                            fontSize: 14,
                            letterSpacing: 1.5,
                            color: primaryColor700,
                            fontWeight: FontWeight.bold,
          
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Le champ ne peut pas être vide';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 40,),
                      GestureDetector(
                        onTap: (){
                          Login();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 16),
                          constraints: BoxConstraints(
                            maxWidth: 200,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: informationColor,
                          ),
                          child: Center(
                            child: Text("Se Connecter",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            ],
          ),
        ),
      ),
    );
  }
  
  void Login() async {
    if(_formKey.currentState!.validate()){
      ApiService().loginUser(usernameController.text, passwordController.text).then((response) async{
        if(response.statusCode == 200){
          final User user = User.fromJson(jsonDecode(response.body));
          user.password = passwordController.text;
          user.savePrefrences();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Homepage()),
          );
        }
      else {
        setState(() {
          if(response.statusCode == 404){
              checkUsername = "Utilisateur non trouvé" ;
          }
          else{
              checkUsername = null ;
          }
          if(response.statusCode == 400){
              checckPassword = "Mot de passe incorrect" ;
          }
          else{
              checckPassword = null ;
          }
        });
      }
       
      });
    }
  }

  Future<void> _checkUsername() async {
 
  await Future.delayed(Durations.medium4);
 
  final username = await User.custom().getUsername();
  if (username.isNotEmpty) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Homepage()),
    );
  }else{
    setState(() {
    _isLoading = false ;
  });
  }
}
}