import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/components/client_tile.dart';
import 'package:sns_app/components/dialog_widget.dart';
import 'package:sns_app/components/worker_tile.dart';
import 'package:sns_app/models/Client.dart';
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
  late Future<List<Client>> futureClients ;
  late Future<List<Client>> futureDeletedClients ;

  final List<String> choices = ['Equipe','Clients','Gallery'];
  int selectedIndex = 0 ;

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>() ;

   @override
   void initState() {
    super.initState();
    futureWorkers = ApiService().fetchAllWorkers();
  }
  bool istest = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selectedIndex != 2 ? FloatingActionButton.small(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: (){
          _showCreateWorkerDialog(context) ;
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
                  margin: EdgeInsets.only(top:20),
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
                              fetchData();
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
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: successColor
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        Text("Disponible",style: TextStyle(
                          color: successColor600,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.5
                        ),)
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: warningColor
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        Text("Indisponible",style: TextStyle(
                          color: warningColor600,
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.2
                        ),)
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: alertColor
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        Text("Eliminé",style: TextStyle(
                          color: alertColor600,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.5
                        ),)
                      ],
                    )
                  ),
                  ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child:FutureBuilder(
                  future: futureWorkers, 
                  builder: (context,snapshot){
                    ////handling serveur delay or issue
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if(!snapshot.hasData){
                        return Center(child: Text('Aucun Ouvrier trouvé'));
                      }
                      List<Worker> availableWorkers = snapshot.data!.where((w) => w.isAvailable && !w.isDeleted).toList();
                      List<Worker> unavailableWorkers = snapshot.data!.where((w) => !w.isAvailable && !w.isDeleted).toList();
                      List<Worker> deletedWorkers = snapshot.data!.where((w) => w.isDeleted).toList();

                      List<dynamic> displayList = [];

                      if (availableWorkers.isNotEmpty) {
                        displayList.addAll(availableWorkers);  
                      }
                      if (unavailableWorkers.isNotEmpty) {
                        displayList.add("Les membres d'equipe non disponible");  
                        displayList.addAll(unavailableWorkers);  
                      }
                      if (deletedWorkers.isNotEmpty) {
                        displayList.add("Les membres d'equipe eliminé");  
                        displayList.addAll(deletedWorkers);  
                      }

                      return displayList.isNotEmpty ? ListView.builder(
                        itemCount: displayList.length,
                        itemBuilder: (context, index) {
                          if (displayList[index] is String) {
                            return Padding(
                              padding: const EdgeInsets.all(10),
                            );
                          } else {
                            Worker worker = displayList[index];
                            return Padding(
                              padding : index == displayList.length - 1
                                      ? const EdgeInsets.only(bottom: 50, top: 15)
                                      : const EdgeInsets.only(top: 15.0),
                              child: WorkerTile(worker: worker),
                            );
                          }
                        },
                      ) :  Center(child: Text('Aucun Ouvrier trouvé'));
                  })
                
              ),
            ),
          ],

          if(selectedIndex == 1)...[
          Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: primaryColor
                              ),
                            ),
                            SizedBox(width: 5.0,),
                            Text("Engagé",style: TextStyle(
                              color: primaryColor600,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.5
                            ),)
                          ],
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: informationColor
                              ),
                            ),
                            SizedBox(width: 5.0,),
                            Text("Fidèle",style: TextStyle(
                              color: informationColor600,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.2
                            ),)
                          ],
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: successColor
                              ),
                            ),
                            SizedBox(width: 5.0,),
                            Text("Occasionnel",style: TextStyle(
                              color: successColor600,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.5
                            ),)
                          ],
                        )
                      ),
                      ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 30, 0),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: warningColor
                              ),
                            ),
                            SizedBox(width: 5.0,),
                            Text("Nouveau",style: TextStyle(
                              color: warningColor600,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.5
                            ),)
                          ],
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Row(
                          children: [
                            Container(
                              height: 15,
                              width: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                color: alertColor
                              ),
                            ),
                            SizedBox(width: 5.0,),
                            Text("Eliminé",style: TextStyle(
                              color: alertColor600,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 1.2
                            ),)
                          ],
                        )
                      ),
                      ],
                  ),
                ],
              ),
            ),
          Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child:FutureBuilder(
                  future: Future.wait([futureClients,futureDeletedClients]), 
                  builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if(!snapshot.hasData){
                        return Center(child: Text('Aucun Clients trouvé'));
                      }
                      if (snapshot.hasError) {
                      return Center(child: Text('Serveur en panne')); 
                      }
                      List<Client> clients = snapshot.data![0] ;
                      List<Client> deletedClients = snapshot.data![1];

                      List<Client> allClients = [...clients, ...deletedClients];

                      return allClients.isNotEmpty ? ListView.builder(
                        itemCount: allClients.isEmpty ? 1 : allClients.length,
                        itemBuilder:(context, index) {
                          return Padding(
                            padding: index == 0 ? EdgeInsets.only(top: 20): index == allClients.length-1 ? EdgeInsets.only(bottom: 50,top: 10) : EdgeInsets.only(top: 10.0),
                            child: ClientTile(client: allClients[index]),
                          ) ;
                        },): Center(child: Text('Aucun Clients trouvé'));
                  })
              ),
            ),
            
          
          ],
        
          if(selectedIndex == 2)...[
            Center(
              child: Switch(
                value: istest, 
                onChanged: (onChanged){
                  setState(() {
                    istest = onChanged ;
                  });
                }),
            )
          ]
        ],
      ),
    );
  }
 
  void _showCreateWorkerDialog(BuildContext context) async{
   await showDialog(
      context: context,
      builder: (BuildContext context) {
        return selectedIndex == 0 ? WorkerDialog() : ClientDialog();
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
                fetchData();
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
  
  void fetchData() {
    if(selectedIndex == 0){
      futureWorkers = ApiService().fetchAllWorkers();
    }
    else if(selectedIndex == 1){
      futureClients = ApiService().fetchAllClients();
      futureDeletedClients = ApiService().fetchAllDeletedClients();
    }
  }
}



class WorkerDialog extends StatefulWidget{

  const WorkerDialog({super.key});

  @override
  State<WorkerDialog> createState() => _WorkerDialog();
  }
  
class _WorkerDialog extends State<WorkerDialog>{

  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _nameController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>() ;

  bool isAvailable = true ;
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: Duration(milliseconds: 400),
      child:SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height*0.6,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                        "AJOUTER OUVRIER",
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
                  height: MediaQuery.sizeOf(context).height*0.5,
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
                        AnimatedToggleSwitch.size(
                          current: isAvailable, 
                          values: const [false,true],
                          iconOpacity: 1,
                          indicatorSize: const Size.fromWidth(100),
                          customIconBuilder: (context, local, global) => Text(
                            local.value ? 'Disponible' : 'Indisponible',
                            style: TextStyle(
                              color: Color.lerp(neutralColor, Colors.white, local.animationValue),
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0,
                              letterSpacing: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          borderWidth: 1.5,
                          iconAnimationType: AnimationType.onHover,
                          animationDuration: Duration(milliseconds: 300),
                          animationCurve: Curves.easeInOut,
                          style: ToggleStyle(
                            indicatorColor: isAvailable ? successColor : warningColor,
                            borderColor: isAvailable ? successColor : warningColor,
                            borderRadius: BorderRadius.circular(10.0),
                            indicatorBorderRadius: BorderRadius.only(
                              topLeft: isAvailable ? Radius.circular(0.0) : Radius.circular(8) ,
                              bottomLeft: isAvailable ? Radius.circular(0.0) : Radius.circular(8) ,
                              topRight: isAvailable ? Radius.circular(8.0) : Radius.circular(0) ,
                              bottomRight: isAvailable ? Radius.circular(8.0) : Radius.circular(0) ,
          
                            )
                            
                          ),
                          selectedIconScale: 1.0,
                          onChanged: (value) => setState(() {
                            isAvailable = value ;
                          }),
                          ),
                        
                        /// buttons
                        GestureDetector(
                          onTap: (){
                            createWorker();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            constraints: BoxConstraints(
                              maxWidth: 200,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              color: successColor600,
                            ),
                            child: Center(
                              child: Text("Ajouter",
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
              
          ),
        ),
      )
    );
     
  }
  void createWorker() async {
    if(_formKey.currentState!.validate()){
      final worker = Worker(id: 0, 
        name: _nameController.text, 
        phoneNumber: _phoneController.text,
        isAvailable: isAvailable, 
        isDeleted: false,
      );
      ApiService().createWorker(worker).then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessWidget(validationMessage:'Ouvrier ${_nameController.text} a été créer avec succés !' ,);
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
}

class ClientDialog extends StatefulWidget{
  const ClientDialog({super.key});

  @override
  State<ClientDialog> createState() => _ClientDialog();
  }
  
class _ClientDialog extends State<ClientDialog>{

  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _noteController = TextEditingController(text: "");
  final _formKey = GlobalKey<FormState>() ;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: Duration(milliseconds: 400),
      child:SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height*0.7,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                        "AJOUTER CLIENT",
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
                  height: MediaQuery.sizeOf(context).height*0.5,
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
                         SizedBox(
                          width: 250,
                          height: 100,
                          child: TextFormField(
                            controller: _noteController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 5,
                            decoration: InputDecoration(
                              labelText: "Remarque",
                              labelStyle: TextStyle(
                                fontSize: 11,
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
                              fontWeight: FontWeight.bold,
          
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return null;
                              }
                              if (!RegExp(r'^[a-zA-Z0-9 ]*$').hasMatch(value)) {
                                return 'Uniquement des caractères alphabétiques et numériques';
                              }
                              return null;
                            },
                          ),
                        ),
                       
                        /// buttons
                        GestureDetector(
                          onTap: (){
                            ajouterClient();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            constraints: BoxConstraints(
                              maxWidth: 200,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.0),
                              color: successColor600,
                            ),
                            child: Center(
                              child: Text("Ajouter",
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
              
          ),
        ),
      )
    );
     
  }
  
    
  void ajouterClient() async {
    if(_formKey.currentState!.validate()){
      final client = Client(id: 0, 
        name: _nameController.text, 
        phoneNumber: _phoneController.text,
        isDeleted: false,
        note: _noteController.text,
      );
      ApiService().createClient(client).then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessWidget(validationMessage:'Client ${_nameController.text} a été créer avec succés !' ,);
                  },
                );
                Navigator.pop(context) ;
            }else {
                String errorMessage = "";
              if (response.statusCode == 400) {
                errorMessage = "Le Nom ou le Téléphone de Client existe déja";
              } else{
                errorMessage = "Échec de la création de Client. Veuillez réessayer." ;
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


