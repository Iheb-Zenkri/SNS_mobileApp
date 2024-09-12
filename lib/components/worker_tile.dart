import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/models/Worker.dart';
import 'package:sns_app/models/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerTile extends StatelessWidget{

  final Worker worker;


  const WorkerTile({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width-50,
      height: 60,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [ BoxShadow(
          color: Colors.black.withOpacity(0.05),
          offset: Offset(0, 0),
          blurRadius: 10,
          spreadRadius: 1,
        ),],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
           color: getColor(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            width: MediaQuery.sizeOf(context).width-60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Iconsax.profile_circle,size: 20,color: primaryColor300,),
                    SizedBox(width: 6,),
                    Text(worker.name,style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: primaryColor600,
                    ),),
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
    );
  }
  
  Color getColor(){
    if(worker.isDeleted) return alertColor;
    if(worker.isAvailable) return successColor ;
    if(!worker.isAvailable)return warningColor ;
    return informationColor ;
  }
}