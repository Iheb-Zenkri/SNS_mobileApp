import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/components/notification_tile.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';

import '../models/Notification.dart';

class NotificationsPage extends StatefulWidget{
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPage() ;
}

class _NotificationsPage extends State<NotificationsPage>{

  List<Notifications> notifications = [];
  final controller = ScrollController();
  bool isTheEnd = false ;
  bool isEmpty = false ;
 @override
  void initState() {
    super.initState();
    refresh();
    controller.addListener((){
      if(controller.position.maxScrollExtent == controller.offset){
        fetch();
      }
    
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor100,
      appBar: AppBar(   
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 1.0,
        centerTitle: true,
        elevation: 0.0,
        title: Text('NOTIFICATIONS',style: TextStyle(
        color: primaryColor600,
        fontWeight:FontWeight.bold,
        letterSpacing: 5.0,
        fontSize: 22,
        ),) ,
        leading:GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Iconsax.arrow_left,size: 30,color: primaryColor,),
        ) ,
      ),

      body:notifications.isNotEmpty ? RefreshIndicator(
        onRefresh: refresh ,
        child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child:ListView.builder(
                controller: controller,
                itemCount: notifications.length +1,
                itemBuilder:(context, index) {
                  return index < notifications.length ? Padding(
                    padding: const EdgeInsets.fromLTRB(5, 8, 5, 0),
                    child: NotificationTile(notification: notifications[index]),
                  )
                      : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: isTheEnd ? SizedBox() 
                              : CircularProgressIndicator(color: informationColor,strokeWidth: 2.0),
                        ),
                      );
                },
              ),
            ),
        ): isEmpty ? Center(child: Text("Aucune Notification Trouvée"),) 
          : Center(child: CircularProgressIndicator(color: informationColor,strokeWidth: 2.0,),
      ),
    );
  }
  
 Future refresh() async {
  ApiService().getNewerNotifications(0).then((response){
    setState(() {
      if(response.isEmpty){
        isTheEnd = true ;
      }else{
        notifications = response ;
        ApiService().markNotificationsAsRead(getMinimumId(response));
      }
    });
  });
/*
   if (notifications.isEmpty) {
    await Future.delayed(Duration(seconds: 1));
    if(mounted){
      setState(() {
        isEmpty = true;
      });
    }
  } */
 }
 
  Future fetch() async {
    int lastId = getMinimumId(notifications);
    ApiService().getolderNotifications(lastId).then((response){
      setState(() {
        if(response.isEmpty){
        isTheEnd = true ;
      }else{
        notifications.addAll(response);
        ApiService().markNotificationsAsRead(getMinimumId(response));
      }
      });
    });

    if (notifications.isEmpty) {
      await Future.delayed(Duration(seconds: 1));
      if(mounted){
        setState(() {
          isEmpty = true;
        });
      }
    }
  }

  int getMinimumId(List<Notifications> objects) {
  if (objects.isEmpty) {
    throw Exception("List is empty");
  }
  return objects.reduce((a, b) => a.id < b.id ? a : b).id;
}
}