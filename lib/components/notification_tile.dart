
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/models/Notification.dart';
import 'package:sns_app/models/User.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';

class NotificationTile extends StatefulWidget{
  final Notifications notification ;
  const NotificationTile({super.key,required this.notification});

  @override
  State<NotificationTile> createState() => _NotificationTile() ;
}

class _NotificationTile extends State<NotificationTile>{

  late Future<User> ownerUser ;
  @override
  void initState() {
    ownerUser = ApiService().getUser(widget.notification.ownerId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final notification = widget.notification ;
    return Stack(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8.0,
                decoration: BoxDecoration(
                  color: getDarkerColor(notification.type),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    bottomLeft: Radius.circular(8.0)
                  )
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width*0.9,
                  constraints: BoxConstraints(
                    minHeight: 50.0,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0)
                    ),
                  boxShadow: [
                    BoxShadow(
                      color: neutralColor800.withOpacity(0.05),
                      offset: Offset(0, 0),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                    ),
                  ]
                  ),  
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: ClipOval(
                              child: Image.asset(
                                'lib/icons/userpic.jpg',
                                width: 24.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 8,),
                          Text('${notification.username!.split(' ').first} ',style: TextStyle(
                                  fontSize: 16,
                                  color: primaryColor,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                  height: 1.0
                                ),),
                          Text(notification.username!.split(' ').last,style: TextStyle(
                            fontSize: 16,
                            color: informationColor300,
                            height: 1.0
                          ),),
                          Spacer(),
                          Text(notification.getTimeAgo().toLowerCase(),style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 0.0,
                            color: informationColor200,
                          ),)
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 15, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(text: formatText(notification.description)),
                              ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.transparent
            ),
            alignment: Alignment.center,
            child: Icon(notification.isRead ?Icons.check_circle_rounded  : Iconsax.tick_circle,
            size: 15,color: neutralColor100,),
          ),
        ),
      ],
    );
  }
  
  Color getDarkerColor(String type) {
  if(type == "create"){
        return successColor;
      }
      if(type == "update"){
        return informationColor ;
      }
      return alertColor ;
  }


 TextSpan formatText(String input) {
  List<TextSpan> spans = [];
  List<String> words = input.split(' ');
  for (String word in words) {
    if (word == word.toUpperCase() && word.length>1) {
      String formattedWord = word[0].toUpperCase() + word.substring(1).toLowerCase();
      spans.add(TextSpan(text: '$formattedWord ', style: TextStyle(
        fontWeight: FontWeight.bold,
        color: neutralColor700,
        fontSize: 11,
        letterSpacing: 1.2,
        fontFamily: 'Nunito'
      )));
    } else {
      for (int i = 0; i < word.length; i++) {
        String char = word[i];
          spans.add(TextSpan(text: char, style: TextStyle(
            fontWeight: FontWeight.normal,
            color: primaryColor700,
            fontSize: 12,
            fontFamily: 'Nunito'
          )));
      }
      spans.add(TextSpan(text: ' ')); 
    }
  }

  return TextSpan(children: spans);
}

}

 