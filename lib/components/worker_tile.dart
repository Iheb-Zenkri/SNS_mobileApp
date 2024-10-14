import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/components/dialog_widget.dart';
import 'package:sns_app/models/Worker.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerTile extends StatefulWidget{
   
  final Worker worker;
  const WorkerTile({super.key, required this.worker});

  @override
  State<WorkerTile> createState() => _WorkerTile();
}

class _WorkerTile extends State<WorkerTile>{

  bool isUpdate = false ;

  @override
  Widget build(BuildContext context) {
    Worker worker = widget.worker ;
    return AnimatedContainer(
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
              Container(
                width: 20,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0),
                  ),
               color: getColor(worker),
                ),
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
                          child: Text(worker.name,style: TextStyle(
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
                            path: worker.phoneNumber,
                          );
                          if (await canLaunchUrl(launchUri)) {
                          await launchUrl(launchUri);
                          }
                      },
                      child: Row(
                        children: [
                          Text(worker.phoneNumber,style: TextStyle(
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
                              worker.isDeleted ? deleteWorker() : sofDeleteWorker() ;
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
                    
                    if(!worker.isDeleted)...[
                      GestureDetector(
                        onTap: (){
                          _showCreateServiceDialog(context);
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
                    if(worker.isDeleted)...[
                      GestureDetector(
                        onTap: (){
                          showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ConfirmWidget(confirmMessage: "Êtes-vous sûr de vouloir restorer ce membre d'Equipe ?",
                          onChange: (isOk) async {
                            if(isOk){
                              restoreDeletedWorker();
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
  
  Color getColor(Worker worker){
    if(worker.isDeleted) return alertColor;
    if(worker.isAvailable) return successColor ;
    return warningColor ;
  }

  void _showCreateServiceDialog(context) async{
   await showDialog(
      context: context,
      builder: (context) {
        return WorkerDialog(worker: widget.worker,) ;
      },
    );
  }

  void sofDeleteWorker() async{
    ApiService().softDeleteWorker(widget.worker.id).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessWidget(validationMessage:'Ouvrier ${widget.worker.name} a été supprimer avec succés !' ,);
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

  void deleteWorker() async{
    ApiService().deleteWorker(widget.worker.id).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessWidget(validationMessage:'Ouvrier ${widget.worker.name} a été supprimer défintifement avec succés !' ,);
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
  
  void restoreDeletedWorker() async {
    setState(() {
      widget.worker.isDeleted = false ;
    });

    ApiService().updateWorker(widget.worker).then((response) async {
      if (response.statusCode == 200 || response.statusCode == 201) {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessWidget(validationMessage:'Ouvrier ${widget.worker.name} a été restorer avec succés !' ,);
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




class WorkerDialog extends StatefulWidget{
  final Worker worker;

  const WorkerDialog({super.key,required this.worker});

  @override
  State<WorkerDialog> createState() => _WorkerDialog();
  }
  
class _WorkerDialog extends State<WorkerDialog>{

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>() ;

  bool isAvailable = false ;
  
  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.worker.phoneNumber ;
    _nameController.text = widget.worker.name ;
    isAvailable = widget.worker.isAvailable;
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
                        "MODIFIER OUVRIER",
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
                            updateWorker();
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
        ),
      )
    );
     
  }
  
    
  void updateWorker() async {
    if(_formKey.currentState!.validate()){
      final worker = Worker(id: widget.worker.id, 
        name: _nameController.text, 
        phoneNumber: _phoneController.text,
        isAvailable: isAvailable, 
        isDeleted: widget.worker.isDeleted
      );
      ApiService().updateWorker(worker).then((response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessWidget(validationMessage:'Ouvrier ${_nameController.text} a été modifier avec succés !' ,);
                  },
                );
                Navigator.pop(context) ;
            }else {
                String errorMessage = "";
              if (response.statusCode == 400) {
                errorMessage = "Le Nom ou le Téléphone d'Ouvrier existe déja";
              } else{
                errorMessage = "Échec de la modification d'Ouvrier. Veuillez réessayer." ;
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

