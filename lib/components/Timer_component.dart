import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/models/colors.dart';

class CronoTimer extends StatefulWidget {
  final int id;
  
  final String time; 

  final bool onlyTimer ;
  
  final void Function()? setTime;

  const CronoTimer({super.key, required this.id ,required this.time,required this.onlyTimer,this.setTime});

  @override
  State<CronoTimer> createState() => _CronoTimerState();

}

class _CronoTimerState extends State<CronoTimer> with SingleTickerProviderStateMixin {

// variables
  String digitSeconds = "00", digitMinutes = "00" , digitHours = "00" ;
  Timer? timer ;
  bool started = false ;
  List laps = [];
  int seconds = 0 , minutes = 0 , hours = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

// comparing time
  @override
  void initState() {
    super.initState();
    TimeOfDay serviceTime = stringToTimeOfDay(widget.time);
    TimeOfDay now = TimeOfDay.now();
    
     if (isAfter(serviceTime, now)) {
        if(now.minute<serviceTime.minute){
            hours = now.hour - serviceTime.hour - 1;
            minutes = now.minute - serviceTime.minute + 60;
        }
        else{
          hours = now.hour - serviceTime.hour;
          minutes = now.minute - serviceTime.minute;
        }
            seconds = 0 ;
            start() ;
          } else {
            hours = minutes = seconds = 0;
          }
  }



  bool isAfter(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }


// functions
  void stop(){
    timer!.cancel();
    setState(() {
      started = false;
    });
  }
  void start(){
      started = true ;
      setState(() {
          digitSeconds = (seconds>9) ? "$seconds" :"0$seconds" ;
          digitMinutes = (minutes>9) ? "$minutes" :"0$minutes" ;
          digitHours = (hours>9) ? "$hours" :"0$hours" ;

        });
      timer = Timer.periodic(Duration(seconds: 1),(timer){
        int localSeconds = (seconds == 59) ? 0 : seconds + 1;
        int localMinutes = (seconds == 59) ? minutes+1  : minutes ;
        int localHours = (minutes == 59 && seconds == 59) ? hours+1 : hours ;

        setState(() {
          seconds = localSeconds ;
          minutes = localMinutes ;
          hours = localHours ;
          digitSeconds = (seconds>9) ? "$seconds" :"0$seconds" ;
          digitMinutes = (minutes>9) ? "$minutes" :"0$minutes" ;
          digitHours = (hours>9) ? "$hours" :"0$hours" ;
          
        });
      });
    }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.onlyTimer)...[
            Text('$digitHours''h $digitMinutes''m',
            style : TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )),
      ],

        if (!widget.onlyTimer) ...[
        Container(
            width: 140,
            height: 130,
            decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0)
            ),
            color: started ? alertColor600 : successColor600,
            ),
            padding: const EdgeInsets.fromLTRB(10, 10, 14, 8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                      width: 1.0,
                      color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$digitHours : ''$digitMinutes',
                            style : TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            )),
                            SizedBox(width: 6,),
                             Text(digitSeconds,
                            style : TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              
                            )),
                      ],
                    ),
                  ),
                 
                  GestureDetector(
                      onTap: (){
                        if(started){
                          stop();
                        }else{
                          start();
                          widget.setTime!();
                        }
                      },
                      child: Container(
                        width: 90,
                        height: 30,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children : [
                            started ? Icon(Iconsax.pause5,size: 20,color: alertColor600,) : Icon(Iconsax.play5,size: 20,color : successColor600),
                            Text(
                              started ? " Finish" : " Start",
                              style: TextStyle(
                                color: started ? alertColor700 : successColor700,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ]
                      ),
                      ),
                    ),
              ],
              ),
              ),
              ]
            ],
    );
  }
  
}

TimeOfDay stringToTimeOfDay(String timeString) {
  final format = timeString.split(":");
  final hour = int.parse(format[0]);
  final minute = int.parse(format[1]);
  return TimeOfDay(hour: hour, minute: minute);
}