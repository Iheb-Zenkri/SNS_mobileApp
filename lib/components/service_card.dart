import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/components/Timer_component.dart';
import 'package:sns_app/components/service_dialog.dart';
import 'package:sns_app/models/data.dart';
import 'package:sns_app/pages/affectation_service.dart';
import 'package:url_launcher/url_launcher.dart';


class ServiceCard extends StatefulWidget {
  final Service service;
  
  const ServiceCard({super.key, required this.service});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends  State<ServiceCard> {

  bool showTimer = false ;
  Timer? _updateTimer;

  static  List<Color> colors = [
    informationColor600,
    informationColor700,
     primaryColor700,
     informationColor600,
    informationColor600,
    ];

  void setTimer(){
    setState(() {
      String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      widget.service.time = currentTime ;
    _updateTimer = Timer(Duration(seconds: 60), () {
        ApiService().updateService(widget.service);
      });});
  }
  void updateServiceImmediately() {
    String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    widget.service.time = currentTime;
    ApiService().updateService(widget.service);
  }

@override
  void dispose(){
    if (_updateTimer?.isActive ?? false) {
      _updateTimer?.cancel();
      updateServiceImmediately();
    }
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service ;
    bool isToday = DateTime.parse(service.date).isBefore(DateTime.now()) && !service.finished;
    return Container(
      height: 130,
      width: 350,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
                color: Colors.white,
                boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07), 
                        offset: Offset(0,10), 
                        blurRadius: 20, 
                        spreadRadius: 1, 
                      ),
                    ],
                ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(!showTimer || !isToday)...[
            Container(
              width: 140,
              decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.0),
                bottomLeft: Radius.circular(4.0)
              ),
              color: colors[service.id%5],
              ),
              padding: const EdgeInsets.fromLTRB(10, 10, 14, 8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        service.type.toUpperCase() ,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
              
                    GestureDetector(
                      onDoubleTap: (){
                        if(isToday){
                          setState(() {
                            showTimer = true;
                          });
                        }
                      },
                      child: Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color : Colors.white,
                            width : 1,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Icon(Iconsax.clock, color: Colors.white,size: 12,), // Time icon
                            const SizedBox(width: 4), // Space between icon and time text
                            Text(
                              service.time.substring(0, 5),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  if(isToday) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CronoTimer(id: service.id, time: service.time, onlyTimer: true,),
                        ],
                      )
                    ]
                  ],
                ),
            ),
          ],
          
          if(showTimer && isToday)...[
            GestureDetector(
              onDoubleTap: (){
                setState(() {
                  showTimer = false ;
                });
              },
              child: CronoTimer(id: service.id, time: service.time, onlyTimer: false,setTime: setTimer,)
              ),
          ],

          Expanded(
            child: Stack(
              children: [
                Padding(
                   padding: const EdgeInsets.fromLTRB(15, 15, 5, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Nom de client",
                        style: TextStyle(
                            fontSize: 10,
                            color: neutralColor200,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                        ),),
                        SizedBox(height: 5,),
                  
                        SizedBox(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${service.client.name.split(' ').first.toUpperCase()} ',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: neutralColor600,
                                    letterSpacing: 2.0,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                ),),
                                Text(
                                  service.client.name.split(' ').length > 1 ? service.client.name.split(' ').last : "" ,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: neutralColor,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w500,
                                    height: 1.0,
                                ),),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                  
                      Text("Téléphone",
                          style: TextStyle(
                            fontSize: 10,
                            color: neutralColor200,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w500,
                        ),),
                        SizedBox(height: 5,),
                      Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color:  successColor600,
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Icon(Iconsax.call5,size: 14,color: successColor100,)),
                            GestureDetector(
                              onTap: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: service.client.phoneNumber,
                                  );
                                  if (await canLaunchUrl(launchUri)) {
                                  await launchUrl(launchUri);
                                  }
                                },
                              child: Text(
                               service.client.phoneNumber.length == 8 ?'  ${service.client.phoneNumber.substring(0,2)} ${service.client.phoneNumber.substring(2,5)} ${service.client.phoneNumber.substring(5)}' : ' ${service.client.phoneNumber}',
                              style: TextStyle(
                                fontSize: 14,
                                color:  successColor600,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0 ,
                              ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10, 
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ServiceDialog(service: service);
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: neutralColor100.withOpacity(0.3),width: 1 ),
                      ),
                      child: Icon(Icons.more_horiz_rounded, size: 16, color: neutralColor200),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  right: 10,
                  child:GestureDetector(
                    onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> AffectationService(service: service,)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: primaryColor200,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(Iconsax.add, size: 15, color: Colors.white),
                    ),
                  ) )
              ],
            ),
          ),
         
       ],
      ),
    );
  }


}
