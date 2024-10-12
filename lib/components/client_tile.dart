import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/components/dialog_widget.dart';
import 'package:sns_app/models/Client.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';
import 'package:url_launcher/url_launcher.dart';

class ClientTile extends StatefulWidget{

  final Client client ;
  const ClientTile({super.key,required this.client});

  @override
  State<ClientTile> createState() => _ClientTile();
}

class _ClientTile extends State<ClientTile>{
  bool isUpdate = false ;
  
  @override
  Widget build(BuildContext context) {
    var client = widget.client ;
    return  AnimatedContainer(
      duration: Duration(milliseconds: 300), // Duration of the animation
      curve: Curves.fastEaseInToSlowEaseOut, 
      width: MediaQuery.sizeOf(context).width-50,
      height: isUpdate ? 110 : 70,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: Offset(0, 0),
          blurRadius: 10,
          spreadRadius: 1,
        ),],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              FutureBuilder(
                future: getColor(),
                builder: (context, snapshot) {
                  return Container(
                    width: 20,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                       color: snapshot.data,
                    ),                    
                  );
                  
                },
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.sizeOf(context).width-60,
                height: 70,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Iconsax.profile_circle,size: 20,color: primaryColor300,),
                            SizedBox(width: 6,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  isUpdate = !isUpdate ;
                                });
                              },
                              child: Text(client.name,style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                color: primaryColor600,
                              ),),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 3, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              FutureBuilder(
                                future: getNbServiceForClient(), 
                                builder:(context, snapshot) {
                                  return Text('${snapshot.data}',style: TextStyle(
                                    fontSize: 10,
                                    color: informationColor200,
                                    fontWeight: FontWeight.bold
                                  ),);
                                }, 
                              ),
                               Text(" Historique des Services",style: TextStyle(
                                fontSize: 10,
                                color: informationColor200,
                                letterSpacing: 1.5,
                              ),),
                            ],
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async{
                         final Uri launchUri = Uri(
                            scheme: 'tel',
                            path: client.phoneNumber,
                          );
                          if (await canLaunchUrl(launchUri)) {
                          await launchUrl(launchUri);
                          }
                      },
                      child: Row(
                        children: [
                          Text(client.phoneNumber,style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: successColor300,
                          ),),
                          SizedBox(width: 6,),
                         Icon(Iconsax.call5,size: 18,color: successColor300,),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          if(isUpdate)...[
            Positioned(
              bottom: 0,
              left: 20,
              child: Container(
                width: MediaQuery.sizeOf(context).width-60,
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(6.0),
                    bottomRight: Radius.circular(6.0),
                  ),
                  color: Colors.white70,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                          setState(() {
                            isUpdate = false ;
                          });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                        margin: EdgeInsets.only(left: 40),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [ BoxShadow(
                            color: Colors.white.withOpacity(0.08),
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),],
                        ),
                        child: Text("Annuler",style: TextStyle(fontSize: 11,color: alertColor200,fontWeight: FontWeight.bold),)
                        ),
                    ),
                    Spacer(),
                    GestureDetector(
                    onTap: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertWidget(errorMessage: "Êtes-vous sûr de vouloir supprimer ce Client ?",isFooter: true,
                          onChange: (isOk) async {
                            if(isOk){
                              client.isDeleted ? deleteClient() : sofDeleteClient() ;
                            }
                          });
                        });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: alertColor,
                        boxShadow: [ BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            offset: Offset(0, 0),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),],
                      ),
                      child: Icon(Iconsax.trash,size: 13,color: Colors.white,),
                    ),
                  ),
                    
                    if(!client.isDeleted)...[
                      GestureDetector(
                        onTap: (){
                          _showUpdateClientDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: informationColor,
                            boxShadow: [ BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              offset: Offset(0, 0),
                              blurRadius: 10,
                              spreadRadius: 1,
                          ),],
                          ),
                          child: Icon(Icons.mode_edit_outline_rounded,size: 13,color: Colors.white,),
                        ),
                      )
                    ],
                    if(client.isDeleted)...[
                      GestureDetector(
                        onTap: (){
                          showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmWidget(confirmMessage: "Êtes-vous sûr de vouloir restorer ce Client ?",
                          onChange: (isOk) async {
                            if(isOk){
                              restoreDeletedClient();
                            }
                          });
                        });
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.0),
                            color: successColor,
                            boxShadow: [ BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              offset: Offset(0, 0),
                              blurRadius: 10,
                              spreadRadius: 1,
                          ),],
                          ),
                          child: Icon(Icons.refresh_rounded,size: 13,color: Colors.white,),
                        ),
                      )
                    ]
                  ],
                ),
              )
            )
          ]
        ],
      ),
    );
  
  }
  
  Future<Color> getColor() async {
    int onValue = await ApiService().getNbServiceForClient(widget.client.id);
    if(widget.client.isDeleted) { return  alertColor ; }
    else if(onValue == 0) { return  warningColor ; }
    else if(onValue~/5 == 0) { return  successColor600; }
    else if(onValue~/5 == 1) { return  informationColor600; }
    else { return  primaryColor700 ; }
  }

  Future<int> getNbServiceForClient() async {
    int onValue = await ApiService().getNbServiceForClient(widget.client.id);
    return onValue ;
  }

  void _showUpdateClientDialog(context) async{
   await showDialog(
      context: context,
      builder: (context) {
        return ClientDialog(client: widget.client) ;
      },
    );
  }

   void sofDeleteClient() async{
    ApiService().softDeleteClient(widget.client.id).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessWidget(validationMessage:'Client ${widget.client.name} a été eliminé avec succés !' ,);
                },
              );
      }else {
        String errorMessage = "Échec de la suppression d'Ouvrier. Veuillez réessayer." ;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertWidget(errorMessage: errorMessage,);
          },
        );
      }
    });
  }

  void deleteClient() async{
    ApiService().permanentlyDeleteClient(widget.client.id).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessWidget(validationMessage:'Client ${widget.client.name} a été définitivement supprimer avec succés !' ,);
                },
              );
      }else {
        String errorMessage = "Échec de la suppression de client. Veuillez réessayer." ;
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertWidget(errorMessage: errorMessage,);
          },
        );
      }
    });
  }
  
  void restoreDeletedClient() async {
    setState(() {
      widget.client.isDeleted = false ;
    });

    ApiService().updateClient(widget.client).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessWidget(validationMessage:'Client ${widget.client.name} a été restorer avec succés !' ,);
                },
              );
      }else {
        String errorMessage = "Échec de la restoration d'Ouvrier. Veuillez réessayer." ;
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


class ClientDialog extends StatefulWidget{
  final Client client;

  const ClientDialog({super.key,required this.client});

  @override
  State<ClientDialog> createState() => _ClientDialog();
  }
  
class _ClientDialog extends State<ClientDialog>{

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>() ;
  
  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.client.phoneNumber ;
    _nameController.text = widget.client.name ;
    _noteController.text = widget.client.note??"";
  }

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
                      "MODIFIER CLIENT",
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
                          updateClient();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                          constraints: BoxConstraints(
                            maxWidth: 200,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.0),
                            color: informationColor,
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
            
        ),
      )
    );
     
  }
  
    
  void updateClient() async {
    if(_formKey.currentState!.validate()){
      final client = Client(id: widget.client.id, 
        name: _nameController.text, 
        phoneNumber: _phoneController.text,
        isDeleted: widget.client.isDeleted,
        note: _noteController.text,
      );
      ApiService().updateClient(client).then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessWidget(validationMessage:'Client ${_nameController.text} a été modifier avec succés !' ,);
                  },
                );
                Navigator.pop(context) ;
            }else {
                String errorMessage = "";
              if (response.statusCode == 400) {
                errorMessage = "Le Nom ou le Téléphone de Client existe déja";
              } else{
                errorMessage = "Échec de la modification de Client. Veuillez réessayer." ;
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

