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
      height: isUpdate ? 100 : 60,
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
                    height: 60,
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
                height: 60,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                          return AlertWidget(errorMessage: "Êtes-vous sûr de vouloir supprimer ce membre d'Equipe ?",isFooter: true,
                          onChange: (isOk) async {
                            if(isOk){
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
                          return ConfirmWidget(confirmMessage: "Êtes-vous sûr de vouloir restorer ce membre d'Equipe ?",
                          onChange: (isOk) async {
                            if(isOk){

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
}