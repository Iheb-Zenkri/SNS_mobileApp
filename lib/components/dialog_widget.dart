
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/models/colors.dart';

class AlertWidget extends StatelessWidget {
  
  final String errorMessage ;
  final bool? isFooter;
  final void Function(bool)? onChange;

  const AlertWidget({super.key, 
                    required this.errorMessage,   
                    this.isFooter ,
                    this.onChange}): assert(
      isFooter == null || onChange != null,
      'onChange is required when isFooter is provided',
    );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: Duration(milliseconds: 400),
      child: IntrinsicHeight(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                width: MediaQuery.sizeOf(context).width*0.8,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.only(
                    topLeft:Radius.circular(6.0),
                    topRight: Radius.circular(6.0),
                  ),
                  color: Colors.white
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: alertColor100
                      ),
                      child: Icon(
                        Iconsax.info_circle,
                        size: 30,
                        color: Colors.red[300],),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "ATTENTION",
                      style: TextStyle(color: neutralColor800,fontSize: 14, fontWeight: FontWeight.w900,letterSpacing: 3.0),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 5,),
                    Text(
                      errorMessage,
                      style: TextStyle(color: neutralColor300,fontSize: 12,letterSpacing: 1.5,fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: null,
                      overflow: TextOverflow.visible,
                    ),
                    
                  ],
                ),
              ),
            Container(
              width: MediaQuery.sizeOf(context).width*0.8,
              height: isFooter??false ? 60 : 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6.0),
                  bottomRight: Radius.circular(6.0),
                ),
              color: alertColor100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if(isFooter ?? false)...[
                  GestureDetector(
                    onTap: (){ 
                      onChange!(false);
                      Navigator.of(context).pop();
                      },
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close,size: 14,color: neutralColor,),
                          SizedBox(width: 4,),
                          Text('Annuler',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: neutralColor),),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      onChange!(true);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: alertColor,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Iconsax.trash,size: 14,color: Colors.white,),
                          SizedBox(width: 4,),
                          Text('Supprimer',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white),),
                        ],
                      ),
                    ),
                  )
                  ],
                ],
              ),
            )
          ]
        ),
      ),
              
    );
  }
}

class ConfirmWidget extends StatelessWidget {

  final String confirmMessage;
  final void Function(bool)? onChange ;
  const ConfirmWidget({super.key, required this.confirmMessage, this.onChange});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: Duration(milliseconds: 400),
      child: IntrinsicHeight(
        child:  Column(
          children: [
           Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
            width: MediaQuery.sizeOf(context).width*0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
            topLeft:Radius.circular(6.0),
            topRight: Radius.circular(6.0),
          ),
              color: Colors.white
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: primaryColor100
                  ),
                  child: Icon(
                    Iconsax.info_circle,
                    size: 30,
                    color: informationColor,),
                ),
                SizedBox(height: 10,),
                Text(
                  "CONFIRMATION",
                  style: TextStyle(color: neutralColor800,fontSize: 14, fontWeight: FontWeight.w900,letterSpacing: 3.0),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5,),
                Text(
                  confirmMessage,
                  style: TextStyle(color: neutralColor300,fontSize: 12,letterSpacing: 1.5,fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width*0.8,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6.0),
                  bottomRight: Radius.circular(6.0),
                ),
              color: primaryColor100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){ 
                      onChange!(false);
                      Navigator.of(context).pop();
                      },
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.close,size: 14,color: neutralColor,),
                          SizedBox(width: 4,),
                          Text('Annuler',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: neutralColor),),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      onChange!(true);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: informationColor,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check,size: 14,color: Colors.white,),
                          SizedBox(width: 4,),
                          Text('Confirmer',style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: Colors.white),),
                        ],
                      ),
                    ),
                  )
                  ],
              ),
            
            )
         ]
        )
      )
    );
  }
}

class SuccessWidget extends StatelessWidget {
  
  final String validationMessage;
  const SuccessWidget({super.key, required this.validationMessage});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.center,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: Duration(milliseconds: 400),
      child: IntrinsicHeight(
        child:  Column(
          children: [
            Container(
                    padding: EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                    width: MediaQuery.sizeOf(context).width*0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topLeft:Radius.circular(6.0),
                    topRight: Radius.circular(6.0),
                  ),
                      color: Colors.white
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: successColor100
                          ),
                          child: Icon(
                            Iconsax.tick_circle,
                            size: 30,
                            color: successColor,),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "VALIDATION",
                          style: TextStyle(color: neutralColor800,fontSize: 14, fontWeight: FontWeight.w900,letterSpacing: 3.0),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 5,),
                        Text(
                          validationMessage,
                          style: TextStyle(color: neutralColor300,fontSize: 12,letterSpacing: 1.5,fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                  ),
            Container(
               width: MediaQuery.sizeOf(context).width*0.8,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(6.0),
                        bottomRight: Radius.circular(6.0),
                      ),
                    color: successColor100,
                    ),
            )
          ],
        ),
             
      )
    );
  }
}
