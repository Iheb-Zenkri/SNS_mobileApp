import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sns_app/components/dialog_widget.dart';
import 'package:sns_app/components/worker_tile.dart';
import 'package:sns_app/models/Worker.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';

class TeamPage extends StatefulWidget {
  
  const TeamPage({super.key});

  
  @override
  State<TeamPage> createState() => _TeamPageState() ;
}

class _TeamPageState extends State<TeamPage> {

  late Future<List<Worker>> futureWorkers ;
  late Future<List<dynamic>> futureEquipments;
  late Future<List<dynamic>> futureServiceGallery ;
  final List<String> choices = ['Equipe','Matériel','Gallery'];
  int selectedIndex = 0 ;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>() ;

  File ? selectedImage ;

   @override
   void initState() {
    super.initState();
    futureWorkers = ApiService().fetchAllWorkers();
    futureEquipments = ApiService().getAllEquipments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selectedIndex != 2 ? FloatingActionButton.small(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: (){
          _showCreateServiceDialog(context) ;
        },
        backgroundColor: primaryColor,
        focusColor: primaryColor200,
        child: Icon(Iconsax.add,color: primaryColor100,),
        ) : null,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                 boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04), 
                      offset: Offset(0,0), 
                      blurRadius: 20, 
                      spreadRadius: 10, 
                    ),
                  ],
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.0),
                  bottomRight: Radius.circular(40.0)
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Management ",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: informationColor700,
                          letterSpacing: 0,
                          fontFamily: 'Nunito'
                        ),),
                        Text("de ressources",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: informationColor200,
                          letterSpacing: 1,
                          fontFamily: 'Nunito'
                        ),),
                      ],
                    ),
                  ),
                 
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection:Axis.horizontal,
                        itemCount: 3,
                        itemBuilder:(context, index) {
                          final bool isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Internal padding
                                decoration: BoxDecoration(
                                    color: isSelected ? informationColor : informationColor100,
                                    borderRadius: BorderRadius.circular(12), 
                                    boxShadow: [
                                        BoxShadow(
                                          color: primaryColor800.withOpacity(0.06), 
                                          offset: Offset(0,4), 
                                          blurRadius: 10, 
                                          spreadRadius: 1, 
                                        ),
                                      ],
                                  ),
                                child: Text(
                                  choices[index],
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? Colors.white : primaryColor300,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                ),
                            )
                            );
                          },),
                    ),
                  )
                ],
              ),
            ),

            if(selectedIndex == 0)...[
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child:FutureBuilder(
                    future: futureWorkers, 
                    builder: (context,snapshot){
                      ////handling serveur delay or issue
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        List<Worker> workers = snapshot.data! ;
                        return ListView.builder(
                          itemCount: workers.isEmpty ? 1 : workers.length,
                          itemBuilder:(context, index) {
                            return Padding(
                              padding: index == 0 ? EdgeInsets.only(top: 20): index == workers.length-1 ? EdgeInsets.only(bottom: 50,top: 10) : EdgeInsets.only(top: 10.0),
                              child: WorkerTile(worker: workers[index]),
                            );
                          },);
                    })
                  
                ),
              ),
            ],

            if(selectedIndex == 1)...[
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child:FutureBuilder(
                  future: futureEquipments, 
                  builder: (context,snapshot){
                    ////handling serveur delay or issue
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No equipment found'));
                      }
                      return GridView.builder(
                        padding: EdgeInsets.all(16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 16.0, // spacing between items horizontally
                          mainAxisSpacing: 16.0, // spacing between items vertically
                          childAspectRatio: 3 / 4, // Adjust the aspect ratio to suit the card layout
                        ),
                        itemCount: snapshot.data!.isEmpty ? 1 : snapshot.data!.length,
                        itemBuilder:(context, index) {
                          final equipement = snapshot.data![index] ;
                          return Stack(
                            fit: StackFit.passthrough,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title
                                      SizedBox(
                                        width: 150,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            equipement['name'],
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      // Image
                                      Center(
                                        child: SizedBox(
                                          height: 100,
                                          child: FutureBuilder(
                                            future: ApiService().getEquipmentImage(equipement['id']),
                                            builder: (context, imageSnapshot) {
                                              if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (imageSnapshot.hasError) {
                                                return Icon(Icons.error);
                                              } else {
                                                return Image.network(
                                                  imageSnapshot.data!,
                                                  fit: BoxFit.cover,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      // Description
                                      Container(
                                        width: 150,
                                        height: 50,
                                        padding: EdgeInsets.all(4.0),
                                        alignment: Alignment.topLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            equipement['description'],
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[700],
                                            ),
                                            maxLines: 3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: informationColor,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.0),
                                      bottomRight: Radius.circular(20.0)
                                    ),
                                  ),
                                  child: Text(
                                    '${equipement['quantity']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  })
              ),
            ),
            ],

            if(selectedIndex == 4)...[
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: FutureBuilder(
                  future: futureServiceGallery, 
                  builder:(context, snapshot) {
                    return Container();
                  },
                )
              ),
            ),
            ],
          ],
        ),
     );
  }
 
  void _showCreateServiceDialog(BuildContext context) async{
   await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          alignment: Alignment.center,
          insetAnimationCurve: Curves.bounceInOut,
          insetAnimationDuration: Duration(milliseconds: 400),
          child:SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: selectedIndex == 0 ? MediaQuery.sizeOf(context).height*0.5 : MediaQuery.sizeOf(context).height*0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(selectedIndex ==0 )...[
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      color: informationColor600,
                      ),
                      child: Center(
                        child: Text(
                            "NOUVEAU OUVRIER",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),),
                      ),
                    ),
                    Container(
                       padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: Colors.white
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height*0.4,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// fields for worker
                            SizedBox(
                              width: 250,
                              height: 60,
                              child: TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: "Nom et Prénom",
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.5,
                                    color: neutralColor200,
                                    fontWeight: FontWeight.bold
                                  ),
                                  filled: true,
                                  fillColor: colorFromHSV(220, 0.06, 1),
                                  suffixIcon: Icon(Icons.person,size: 18,color: primaryColor,),
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
                                ),
                                style:  TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                  color: primaryColor700,
                                  fontWeight: FontWeight.bold
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Le champ ne peut pas être vide';
                                  }
                                  if (!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+){0,2}$').hasMatch(value)) {
                                    return 'Uniquement des caractères alphabétiques';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              height: 60,
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Téléphone",
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.5,
                                    color: neutralColor200,
                                    fontWeight: FontWeight.bold
                                  ),
                                  filled: true,
                                  fillColor: colorFromHSV(220, 0.06, 1),
                                  suffixIcon: Icon(Iconsax.call5,size: 18,color: primaryColor,),
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
                                ),
                                style:  TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                  color: primaryColor700,
                                  fontWeight: FontWeight.bold
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Le champ ne peut pas être vide';
                                  }
                                  if (!RegExp(r'^[0-9]{8}$').hasMatch(value)) {
                                    return 'Un numéro valide est à 8 chiffres';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            /// buttons
                            GestureDetector(
                              onTap: (){
                                addWorker();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                constraints: BoxConstraints(
                                  maxWidth: 200,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0),
                                  color: alertColor,
                                ),
                                child: Center(
                                  child: Text("Confirmer",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0
                                  ),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    )
              
                  ],
                  if(selectedIndex == 1)...[
                    Container(
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      color: informationColor600,
                      ),
                      child: Center(
                        child: Text(
                            "NOUVEAU MATERIEL",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: Colors.white
                      ),
                      width: MediaQuery.sizeOf(context).width,
                      height: MediaQuery.sizeOf(context).height*0.6,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /// fields for worker
                            SizedBox(height: 20,),
                            SizedBox(
                              width: 250,
                              height: 60,
                              child: TextFormField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                  labelText: "Titre",
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.5,
                                    color: neutralColor200,
                                    fontWeight: FontWeight.bold
                                  ),
                                  filled: true,
                                  fillColor: colorFromHSV(220, 0.06, 1),
                                  suffixIcon: Icon(Icons.title_rounded,size: 18,color: primaryColor,),
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
                                ),
                                style:  TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                  color: primaryColor700,
                                  fontWeight: FontWeight.bold
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Le champ ne peut pas être vide';
                                  }
                                  if (!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+){0,2}$').hasMatch(value)) {
                                    return 'Uniquement des caractères alphabétiques';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                             SizedBox(
                              width: 250,
                              height: 100,
                              child: TextFormField(
                                maxLines: 4,
                                textAlign: TextAlign.start,
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Description",
                                  labelStyle: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 1.5,
                                    color: neutralColor200,
                                    fontWeight: FontWeight.bold
                                  ),
                                  filled: true,
                                  fillColor: colorFromHSV(220, 0.06, 1),
                                  suffixIcon: Icon(Icons.description_rounded,size: 18,color: primaryColor,),
                                  
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
                                ),
                                style:  TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 1.5,
                                  color: primaryColor700,
                                  fontWeight: FontWeight.bold
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Le champ ne peut pas être vide';
                                  }
                                  if (!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+){0,2}$').hasMatch(value)) {
                                    return 'Uniquement des caractères alphabétiques';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 60,
                                  child: TextFormField(
                                    controller: _quantityController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                      labelText: "Quantité",
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
                                    ),
                                    style:  TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 1.5,
                                      color: primaryColor700,
                                      fontWeight: FontWeight.bold
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Le champ ne peut pas être vide';
                                      }
                                      if (!RegExp(r'^(100|[1-9][0-9]?)$').hasMatch(value)) {
                                        return 'Un nombre compris entre 1 et 100';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                CustomPaint(
                                  painter: DashedBorderPainter(),
                                  child: GestureDetector(
                                    onTap: (){
                                      _pickImage();
                                    },
                                    child: selectedImage == null ?
                                    Container(
                                      height: 80,
                                      width: 100,
                                      color: informationColor100,
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "AJOUTER",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor600,
                                            ),),
                                            Text(
                                            "une photo",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor600,
                                            ),),
                                         
                                        ],
                                      ),
                                    ) : SizedBox(
                                      height: 100,
                                      width: 100,
                                      child : Image.file(
                                        File(selectedImage!.path).absolute,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,

                                      )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            /// buttons
                            SizedBox(height: 30,),
                            GestureDetector(
                              onTap: (){
                                addEquipement();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                constraints: BoxConstraints(
                                  maxWidth: 200,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14.0),
                                  color: alertColor,
                                ),
                                child: Center(
                                  child: Text("Confirmer",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0
                                  ),),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    )
                  ],
                ],
              ),
            ),
          )
        );
      },
    );
  }
  
  void addWorker() async {
    if(_formKey.currentState!.validate()){
      final worker = Worker(id: 0, 
        name: _nameController.text, 
        phoneNumber: _phoneController.text,
        isAvailable: true, 
        isDeleted: false
      );
      ApiService().createWorker(worker).then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessWidget(validationMessage:'Ouvrier ${_nameController.text} a été créé avec succés !' ,);
                  },
                );
                Navigator.pop(context) ;
            }else {
                String errorMessage = "";
              if (response.statusCode == 400) {
                errorMessage = "Le Nom ou le Téléphone d'Ouvrier existe déja";
              } else{
                errorMessage = "Échec de la création d'Ouvrier. Veuillez réessayer." ;
              }
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertWidget(errorMessage: errorMessage,);
                  },
                );
            }
      });    
    }
  }
  
  Future _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? returnedImage = await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    if(returnedImage != null){
      ApiService().uploadEquipementImage(1,File(returnedImage.path));
      setState(() {
        selectedImage = File(returnedImage.path);
      });
    }else{
      print('no image selected');
    }
  }
  
  void addEquipement() {
    if(_formKey.currentState!.validate()){
      final equipement = {
        "name" : _nameController.text,
        "description" : _phoneController.text,
        "quantity" : double.parse(_quantityController.text)
      };
      ApiService().createEquipement(equipement).then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
            ApiService().uploadEquipementImage(json.decode(response.body)['id'],selectedImage).then((Imageresponse) async {
              if (Imageresponse.statusCode == 200 || Imageresponse.statusCode == 201) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessWidget(validationMessage:'Image de ${_nameController.text} a été créé avec succés !' ,);
                  },
                );
                Navigator.pop(context);
              }else {
                String errorMessage = "";
                errorMessage = "Échec de lire l'image. Veuillez réessayer." ;
                await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertWidget(errorMessage: errorMessage,);
                    },
                  );
                ApiService().deleteEquipement(json.decode(response.body)['id']);
              }
            });
        }else {
            String errorMessage = "";
          if (response.statusCode == 400) {
            errorMessage = "Ce type de matériel s'existe déja";
          } else{
            errorMessage = "Échec de la création de matériel. Veuillez réessayer." ;
          }
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertWidget(errorMessage: errorMessage,);
              },
            );
        }
      });    
    }
  }



}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 7.0;
    double dashSpace = 3.0;
    final paint = Paint()
      ..color = informationColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var path = Path();

    // Top side
    double startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, 0);
      startX += dashWidth;
      path.lineTo(startX, 0);
      startX += dashSpace;
    }

    // Right side
    double startY = 0;
    while (startY < size.height) {
      path.moveTo(size.width, startY);
      startY += dashWidth;
      path.lineTo(size.width, startY);
      startY += dashSpace;
    }

    // Bottom side
    startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, size.height);
      startX += dashWidth;
      path.lineTo(startX, size.height);
      startX += dashSpace;
    }

    // Left side
    startY = 0;
    while (startY < size.height) {
      path.moveTo(0, startY);
      startY += dashWidth;
      path.lineTo(0, startY);
      startY += dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}