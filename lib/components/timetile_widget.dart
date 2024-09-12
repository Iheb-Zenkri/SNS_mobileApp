import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/components/service_dialog.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/colors.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class TimetileWidget extends StatelessWidget{

  final Service service;
  const TimetileWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      height: 70,
      width: MediaQuery.sizeOf(context).width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(service.time.substring(0,5),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: service.finished ? neutralColor200 : informationColor300,
                fontSize: 15
              ),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width-70,
            child: TimelineTile(
              alignment: TimelineAlign.center,
              axis: TimelineAxis.horizontal,
              isFirst: false,
              indicatorStyle: IndicatorStyle(
                indicatorXY: 0.4+service.id%10/50,
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                width: 220,
                height: 50 ,
                indicator: Container(
                  width: 220,
                  padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: service.finished ? neutralColor200 : informationColor200)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        margin: EdgeInsets.only(right: 12.0),
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                            color: service.finished ? neutralColor200 : informationColor200,
                            width: 1
                            ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Iconsax.profile_2user5,
                                color: service.finished ? neutralColor200 : informationColor,
                                size: 20,
                            ),
                            Text('${service.nbWorkers}',
                              style: TextStyle(
                                fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: service.finished ? neutralColor200 : informationColor
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ServiceDialog(service: service);
                              },
                            );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service.type.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: service.finished ? neutralColor200 : informationColor
                                ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    '${service.client.name.split(' ').first.toUpperCase()} ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: service.finished ? neutralColor100 : primaryColor200,
                                      fontWeight: FontWeight.bold,
                                  ),),
                                Text(
                                  service.client.name.split(' ').length > 1 ? service.client.name.split(' ').last : "" ,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: service.finished ? neutralColor100 : primaryColor200,
                                    fontWeight: FontWeight.w500,
                                ),),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
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
                        child: Icon(Iconsax.call5,size: 20,color: service.finished ? neutralColor200 : primaryColor,)
                      ),
                    ],
                  ),
                )
              ),
              afterLineStyle: LineStyle(
                thickness: 1,
                color: service.finished ? neutralColor100 : informationColor300,
              ),
              beforeLineStyle: LineStyle(
                thickness: 1,
                color: service.finished ? neutralColor100 : informationColor300,
              ),
            ),
          )
        ],
      ),
    );
  }
 
}