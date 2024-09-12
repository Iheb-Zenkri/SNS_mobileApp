import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/components/timetile_widget.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';
import 'package:sns_app/models/websocket_config.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  DatePickerController datePickerController = DatePickerController();

  DateTime selectedDate = DateTime.now();
  int selectedMonth = DateTime.now().month - 1;
  int  selectedYear = DateTime.now().year;
  List<int> nbService = [0,0];

  final List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];
  
  final List<int> years = [2024, 2025, 2026, 2027, 2028, 2029, 2030];

  late Future<List<Service>> futureService ;
  
//// handling real time data 
  late WebSocketService webSocketService;
  void initializeWebSocket() {
      webSocketService = WebSocketService();
      if(mounted){
        webSocketService.connect();
        webSocketService.stream.listen((message) {
          setState(() {
            getData();
            getNbService();
          });
        });
      }
  }
////////////////////////////////

   @override
  void initState(){
    super.initState();
    getData();
    getNbService();  
    initializeWebSocket(); 
    WidgetsBinding.instance.addPostFrameCallback((_) {
      datePickerController.animateToDate(selectedDate);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorFromHSV(220, 0.02, 1.0),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        //// header params 
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04), 
                      offset: Offset(0,0), 
                      blurRadius: 20, 
                      spreadRadius: 10, 
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  )
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 //// Title of Page
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                    width: MediaQuery.sizeOf(context).width,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Planning ",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: informationColor700,
                          letterSpacing: 0,
                          fontFamily: 'Nunito'
                        ),),
                        Text("de service ",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: informationColor200,
                          letterSpacing: 1,
                          fontFamily: 'Nunito'
                        ),),
                      ],
                    ),
                  ),
                  
                //// Month and Year selection Area
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.fromLTRB(15.0,20,15,20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 140,                
                          child: DropdownButtonFormField<String>(
                            value: months[selectedMonth],
                            decoration: InputDecoration(
                              labelText: " Mois ",
                              labelStyle: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1.5,
                                color: informationColor200,
                                fontWeight: FontWeight.bold
                              ),                        
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor200,width: 1.5,),
                                gapPadding: 0,
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor200,width: 1.5,),
                                gapPadding: 0,
                              ),
                            ),
                            isExpanded: true,
                            icon: Icon(Iconsax.arrow_down_1,size: 18,color: informationColor,),
                            isDense: false,
                            selectedItemBuilder: (BuildContext context) {
                              return months.map<Widget>((String value) {
                                return Center(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: neutralColor800,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            items: months.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: neutralColor800,
                                      letterSpacing: 2.0,
                                    ),
                                ),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                              selectedMonth = months.indexOf(newValue?? months[selectedMonth]) ;  
                              selectedDate = DateTime(selectedYear,selectedMonth+1,1); 
                              getData();
                              getNbService();
                              });
                            },
                            menuMaxHeight: 150,   
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: 90,
                          child: DropdownButtonFormField<int>(
                            value: selectedYear,
                            decoration: InputDecoration(
                              labelText: " Année ",
                              labelStyle: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1.5,
                                color: informationColor200,
                                fontWeight: FontWeight.bold
                              ),                        
                              enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: informationColor200,width: 1.5,),
                                    gapPadding: 0,
                                  ),
                              focusedBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(color: informationColor200,width: 1.5,),
                                    gapPadding: 0,
                                  ),
                            ),
                            
                            isExpanded: true,
                            icon: Icon(Iconsax.arrow_down_1, size: 18, color: informationColor),
                            alignment: AlignmentDirectional.center,
                            isDense: false,
                            selectedItemBuilder: (BuildContext context) {
                              return years.map<Widget>((int value) {
                                return Center(
                                  child: Text(
                                    value.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: neutralColor800,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            items: years.map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: neutralColor800,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedYear = newValue?? selectedYear;
                                selectedDate = DateTime(selectedYear,selectedMonth+1,1);
                                getData(); 
                                getNbService();
                              });
                            },
                            menuMaxHeight: 150,
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            color: informationColor100,
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.only(top:3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                               Text('${nbService[1]}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,letterSpacing: 1,color:informationColor,)),
                               Text('/${nbService[0]}',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,letterSpacing: 1,color:informationColor200,))

                      ],),
                        ),
                      ],
                    ),
                  ),
                
                //// Date Selection Area
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0)
                      )
                    ),
                    child: DatePicker(
                      controller: datePickerController,
                      startDate() , 
                      height: 70,
                      width: 50,
                      daysCount: numDays(),
                      locale: "fr_FR",
                      initialSelectedDate: selectedDate,
                      selectionColor: informationColor,
                      selectedTextColor: Colors.white,
                      monthTextStyle: TextStyle(
                        fontSize: 0,
                        ),
                      dateTextStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: neutralColor100,
                      ),
                      dayTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: neutralColor100,
                      ),
                      onDateChange: (date){
                        setState(() {
                          selectedDate = date ;
                          getData();
                        });
                      },
                      
                    ),
                  ),
                
              ],
            ),
          ),

        //// Shedule display Area
          Expanded(
            child: FutureBuilder<List<Service>>(
                  future: futureService, 
                  builder: (context, snapshot){

                    ////handling serveur delay or issue
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: Le serveur est en panne !! ${snapshot.error}'));
                    } else if(snapshot.hasData){

                        //// filtre services by date and display it
                        List<Service> filteredServices = snapshot.data! ;            
                        filteredServices.sort((a, b) {
                            return a.time.compareTo(b.time);
                        });
                        return ListView.builder(
                        itemCount:  filteredServices.isEmpty ? 1 :filteredServices.length,
                        itemBuilder:(context, index){
                          return filteredServices.isEmpty ? 
                                  SizedBox(
                                    height: 300, 
                                    child: 
                                    Center(
                                      child: 
                                      Text('Aucun service pour ${months[selectedMonth]} ${selectedDate.day} $selectedYear ')
                                    )) 
                                  : TimetileWidget( service: filteredServices[index]);
                        },
                        );

                    }else {
                      return Center(child: Text('No services available.'));
                    }
                  })
              
             )
        ],
      ),
    );
  }
  
  DateTime startDate(){
    return DateTime(selectedYear,selectedMonth+1,1) ;
  }

  int numDays(){
    return DateTime(selectedYear,selectedMonth+2,1).subtract(Duration(days: 1)).day ;
  }

  void getData(){
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    futureService = ApiService().fetchServiceByDate(date);
  }

  void getNbService(){
    String date = DateFormat('yyyy-MM-dd').format(selectedDate);
    ApiService().fetchServiceCountByMonth(date).then((response){
      setState(() {
        nbService = response;
      });
    });
  }
}
