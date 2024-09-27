import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/components/dialog_widget.dart';
import 'package:sns_app/components/new_service.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';

class EquipementTile extends StatefulWidget{
  
  final dynamic equipement ;

  const EquipementTile({super.key, required this.equipement});

  @override
  State<EquipementTile> createState() => _EquipementTile() ;

}

class _EquipementTile extends State<EquipementTile>{
  
  
  @override
  Widget build(BuildContext context) {
    final equipement = widget.equipement;
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
                  width: 130,
                  height: 50,
                  padding: EdgeInsets.all(4.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    equipement['description'],
                    style: TextStyle(
                      fontSize:equipement['description'].length<40 ? equipement['description'].length>20 ? 12 : 14 : 10,
                      color: Colors.grey[700],
                    ),
                    maxLines: equipement['description'].length%20+1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
                  ],
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertWidget(errorMessage: 'Êtes-vous sûr de vouloir supprimer ce Matériel ?',isFooter: true,
                      onChange: (isOk) async {
                        if(isOk){
                          deleteEquipement(equipement['id']);
                          }
                      });
                    });
                },
                child: Container(
                  padding: EdgeInsets.all(4.0),
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
                  child: Icon(Iconsax.trash,size: 10,color: Colors.white,),
                ),
              ),
              SizedBox(height: 5,),
              GestureDetector(
                  onTap: (){
                    updateEquipement(equipement);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.0),
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
                    child: Icon(Icons.mode_edit_outline_rounded,size: 10,color: Colors.white,),
                  ),
                )
            ],
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
  }

  void deleteEquipement(int id) async{
  ApiService().deleteEquipement(id).then((response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessWidget(validationMessage:'Le Matériel a été supprimer avec succés !' ,);
        },
      );
    }else {
      String errorMessage = "Échec de la suppression de Matériel. Veuillez réessayer." ;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertWidget(errorMessage: errorMessage,);
        },
      );
    }
  });
}

  void updateEquipement(dynamic equipement) async {
    final TextEditingController _descriptionController = TextEditingController(text: equipement['description']);
    final TextEditingController _nameController = TextEditingController(text: equipement['name']);
    final TextEditingController _quantityController = TextEditingController(text: '${equipement['quantity']}');
    final _formKey = GlobalKey<FormState>() ;

    update(){
          final newEquipement = {
            "id" : equipement['id'],
            "name" : _nameController.text,
            "description" : _descriptionController.text,
            "quantity" : double.parse(_quantityController.text)
          };
          ApiService().updateEquipement(newEquipement).then((response) async {
            if (response.statusCode == 200 || response.statusCode == 201) {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SuccessWidget(validationMessage:'Matériel ${_nameController.text} a été modifier avec succés !' ,);
                  },
                );
                Navigator.pop(context) ;
            }else {
                String errorMessage = "";
              if (response.statusCode == 400) {
                errorMessage = "Ce Matériel existe déja";
              } else{
                errorMessage = "Échec de la modification de Matériel. Veuillez réessayer." ;
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
              height: MediaQuery.sizeOf(context).height*0.8,
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
                            "MODIFIER MATERIEL",
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
                              controller: _descriptionController,
                              keyboardType: TextInputType.text,
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
                                if (!RegExp(r'^[a-zA-Z]+( [a-zA-Z]+)*$').hasMatch(value)) {
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
                                    keyboardType: TextInputType.number,
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
                                    },
                                    child: Container(
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
                                    ), 
                                    ),
                                  ),
                                ]
                              ),
                            /// buttons
                            SizedBox(height: 30,),
                            GestureDetector(
                              onTap: (){
                                if(_formKey.currentState!.validate()){
                                  update();
                                }
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
                                  child: Text("Modifier",
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
      },
    );
  }
}