import 'package:flutter/material.dart';
import 'package:sns_app/components/worker_tile.dart';
import 'package:sns_app/models/Worker.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';

class TeamPage extends StatefulWidget {
  
  const TeamPage({super.key});

  
  @override
  State<TeamPage> createState() => _TeamPageState() ;
}

class _TeamPageState extends State<TeamPage> {

  late Future<List<Worker>> futureWorkers ;
  late Future<List<dynamic>> futireEquipments;

  final List<String> choices = ['Equipe','Matériel','Gallery'];
  int selectedIndex = 0 ;

   @override
   void initState() {
    super.initState();
    futureWorkers = ApiService().fetchAllWorkers();
    futireEquipments = ApiService().getAllEquipments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  bottomRight: Radius.circular(40.0)
                ),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                    width: MediaQuery.sizeOf(context).width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Management ",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: informationColor700,
                          letterSpacing: 0,
                          fontFamily: 'Nunito'
                        ),),
                        Text("de ressources",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: informationColor200,
                          letterSpacing: 1,
                          fontFamily: 'Nunito'
                        ),),
                      ],
                    ),
                  ),
                 
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 15, 5, 15),
                    child: SizedBox(
                      height: 60,
                      child: ListView.builder(
                        scrollDirection:Axis.horizontal,
                        itemCount: 3,
                        itemBuilder:(context, index) {
                          final bool isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Internal padding
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
                                child: Text(
                                  choices[index],
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? Colors.white : primaryColor300,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                ),
                            )
                            );
                          },),
                    ),
                  )
                ],
              ),
            ),

            if(selectedIndex == 0)...[
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child:FutureBuilder(
                    future: futureWorkers, 
                    builder: (context,snapshot){
                      ////handling serveur delay or issue
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        List<Worker> workers = [] ;
                        workers.addAll(snapshot.data!);
                        workers.addAll(snapshot.data!);
                        return ListView.builder(
                          itemCount: workers.isEmpty ? 1 : workers.length,
                          itemBuilder:(context, index) {
                            return Padding(
                              padding: index == 0 ? EdgeInsets.only(top: 20): index == workers.length-1 ? EdgeInsets.only(bottom: 50,top: 10) : EdgeInsets.only(top: 10.0),
                              child: WorkerTile(worker: workers[index]),
                            );
                          },);
                    })
                  
                ),
              ),
            ],

            if(selectedIndex == 1)...[
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child:FutureBuilder(
                  future: futireEquipments, 
                  builder: (context,snapshot){
                    ////handling serveur delay or issue
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No equipment found'));
                      }
                      return GridView.builder(
                        padding: EdgeInsets.all(16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 16.0, // spacing between items horizontally
                          mainAxisSpacing: 16.0, // spacing between items vertically
                          childAspectRatio: 3 / 4, // Adjust the aspect ratio to suit the card layout
                        ),
                        itemCount: snapshot.data!.isEmpty ? 1 : snapshot.data!.length,
                        itemBuilder:(context, index) {
                          final equipement = snapshot.data![index] ;
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
                                        width: 150,
                                        height: 50,
                                        padding: EdgeInsets.all(4.0),
                                        alignment: Alignment.topLeft,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            equipement['description'],
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.grey[700],
                                            ),
                                            maxLines: 3,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                        });
                  })
              ),
            ),
            ],

            if(selectedIndex == 2)...[
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child:FutureBuilder(
                  future: futureWorkers, 
                  builder: (context,snapshot){
                    ////handling serveur delay or issue
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      List<Worker> workers = [] ;
                      workers.addAll(snapshot.data!);
                      workers.addAll(snapshot.data!);
                      return ListView.builder(
                        itemCount: workers.isEmpty ? 1 : workers.length,
                        itemBuilder:(context, index) {
                          return Padding(
                            padding: index == 0 ? EdgeInsets.only(top: 20): index == workers.length-1 ? EdgeInsets.only(bottom: 50,top: 10) : EdgeInsets.only(top: 10.0),
                            child: WorkerTile(worker: workers[index]),
                          );
                        },);
                  })
                
              ),
            ),
            ],
          ],
        ),
     );
  }


}