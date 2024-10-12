import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';
import '../models/Service.dart';
import '../components/service_card.dart';

class AccueilPage extends StatefulWidget {
  
  const AccueilPage({super.key});

  
  @override
  State<AccueilPage> createState() => _AccueilPageState() ;
}

class _AccueilPageState extends State<AccueilPage> {

  int _selectedDayIndex = 0;


  final List<String> days =["Aujourd'hui","Demain","Aprés Demain","Cette Semaine"] ;

// new code for api
  late Future<List<Service>> futureService ;

 
  @override
  void initState(){
    super.initState();
    getDatabyDay();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor100,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)
                ),
              color: Colors.white,
              ),
              child: SizedBox(
                  height: 60 ,
                  child: ListView.builder(
                    itemCount: days.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final bool isSelected = _selectedDayIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDayIndex = index;
                            getDatabyDay();
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10), 
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? informationColor : informationColor100,
                              borderRadius: BorderRadius.circular(12), 
                              boxShadow: [
                                  BoxShadow(
                                    color: primaryColor800.withOpacity(0.06), 
                                    offset: Offset(0,4), 
                                    blurRadius: 10, 
                                    spreadRadius: 1, 
                                  ),
                                ],
                            ),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Internal padding
                            child: Text(
                              days[index],
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : primaryColor300,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ),

            Expanded(
                child: FutureBuilder<List<Service>>(
                  future: futureService, 
                  builder: (context, snapshot){

                    ////handling serveur delay or issue
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: Le serveur est en panne !!'));
                    } else if(snapshot.hasData){

                    /// displayin rest of the week                      
                      if (_selectedDayIndex == 3) {
                        return FutureBuilder(
                          future: servicesByDate(), 
                          builder: (context,snapshot){
                            if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }else {

                           List<MapEntry<String,List<Service>>> services = snapshot.data!.entries.toList();
                            int itemCount = services.fold(0, (sum, entry) => sum + entry.value.length + 1);

                            return itemCount>5 ? ListView.builder(
                              itemCount: itemCount,
                              itemBuilder: (context,index){
                                int currentIndex = 0;
                                for (var entry in services) {
                                  String date = formattedDate(entry.key);
                                  List<Service> serviceList = entry.value;
                                  if (index == currentIndex && serviceList.isNotEmpty) {
                                    return Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
                                      margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: informationColor100,width: 1.5),
                                        color: Colors.white,
                                      ),
                                      child: Text(
                                        date, 
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: informationColor600,letterSpacing: 1.5),
                                      ),
                                    );
                                  }
                                  if (index > currentIndex && index <= currentIndex + serviceList.length) {
                                    return ServiceCard(service: serviceList[index - currentIndex - 1]);
                                  }
                                  currentIndex += serviceList.length + 1;
                                }
                                return SizedBox.shrink(); 
                            }) : Text("Aucun service pour la reste de semaine");
                          }
                          });
                        }


                    //// filtre services by date and display it
                      List<Service> filteredServices = snapshot.data!;
                      filteredServices.sort((a, b) => a.time.compareTo(b.time));
                      return ListView.builder(
                      itemCount:  filteredServices.isEmpty ? 1 :filteredServices.length,
                      itemBuilder:(context, index){
                        return filteredServices.isEmpty ? 
                                SizedBox(
                                  height: 300, 
                                  child: 
                                  Center(
                                    child: 
                                    Text('Aucun service pour ${days[_selectedDayIndex]} ')
                                  )) 
                                : Container(
                                  margin: index != 0 ? ( index == filteredServices.length-1 ? EdgeInsets.only(bottom: 70) : EdgeInsets.all(0.0) ) : EdgeInsets.only(top: 10),
                                  child: ServiceCard( service: filteredServices[index]));
                      },
                      );
                    }else {
                      return Center(child: Text('No services available.'));
                    }
                  })
              
              )
          ],
        )
    );    
  }
  
  String formattedDate(String date) {
    DateTime parsedDate = DateTime.parse(date);  // Parse 'yyyy-MM-dd' format
    String formatted = DateFormat('EEEE , d MMMM', 'fr_FR').format(parsedDate);
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  void getDatabyDay(){
    String date = "" ;
      switch(_selectedDayIndex){
        case 0 :
          date = DateFormat('yyyy-MM-dd').format(DateTime.now());
          break;
        case 1 :
          date = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 1)));
          break;
        case 2 :
          date = DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 2)));
          break;
        default :
           date = DateFormat('yyyy-MM-dd').format(DateTime.now());
          break;
      }
      futureService = ApiService().fetchServiceByDate(date);
  }
  
  Future<Map<String, List<Service>>> servicesByDate() async {
    Map<String, List<Service>> servicesByDate = {};

    List<DateTime> dates = [
      DateTime.now().add(Duration(days: 3)),
      DateTime.now().add(Duration(days: 4)),
      DateTime.now().add(Duration(days: 5)),
      DateTime.now().add(Duration(days: 6)),
    ];

    await Future.wait(dates.map((date) async {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      List<Service> response = await ApiService().fetchServiceByDate(formattedDate);
      servicesByDate[formattedDate] = response.isNotEmpty ? response : [];
    }));

    return servicesByDate;
  }
}
