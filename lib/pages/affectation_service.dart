import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/Worker.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';

class AffectationService extends StatefulWidget{
  final Service service;

  const AffectationService({super.key, required this.service});

  @override
  State<AffectationService> createState() => _AffectationService() ;
}

class _AffectationService extends State<AffectationService>{
  
  final List<String> choices = ['Equipe','Matériel','Gallery'];
  int selectedIndex = 0 ;
  
  List<Worker> workersNames = [];
  List<Worker> workers = [];
  late Future<List<Worker>> futureWorkers ;
  late Future<List<Worker>> futureAffectedWorker ;

  @override
   void initState() {
    super.initState();
    futureWorkers = ApiService().fetchWorkersByDate(widget.service.date);
    futureAffectedWorker = ApiService().getServiceWorker(widget.service.id);
  }
  
  @override
  Widget build(BuildContext context) {
    final service = widget.service ;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

        /// Header that conatains client name and feedbacks
        /// about which worker he needs and which he doesnt
        /// and the menu to affect new workers materiel or images
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 20),
                  width: MediaQuery.sizeOf(context).width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: (){ Navigator.pop(context, null); },
                        child:Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(right: 30),
                          child: Icon(Iconsax.arrow_left,color: primaryColor600,)) ,
                      ),
                      
                      Text("Ressources ",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: informationColor700,
                        letterSpacing: 0,
                        fontFamily: 'Nunito'
                      ),),
                      Text("de service",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                        color: informationColor200,
                        letterSpacing: 1,
                        fontFamily: 'Nunito'
                      ),),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  width: MediaQuery.sizeOf(context).width,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          decoration: BoxDecoration(
                            color: primaryColor200,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12.0)
                            )
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 300,
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
                                SizedBox(height: 12,),
                                Flexible(
                                  child: Text(
                                    "Aucune remarque"
                                  ))
                          
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 12,
                          decoration: BoxDecoration(
                            color: primaryColor200,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12.0)
                            )
                          ),
                        ),
                        
                      ],
                    ),
                  )
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor200,width: 0.5)
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder:(context, index) {
                      final bool isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          if(!service.equipment & (index == 1)){}
                          else{
                            setState(() {
                              selectedIndex = index;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width/3-16,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? primaryColor200 : Colors.transparent,                              
                              borderRadius: BorderRadius.circular(8.0)
                            ),
                            child: Text(
                              choices[index],
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : primaryColor300,
                                letterSpacing: 1.0,
                                decoration: !service.equipment & (index == 1) ? TextDecoration.lineThrough : null ,
                              ),
                            ),
                            ),
                        )
                        );
                      },),
                )
              ],
            ),
          ),
          
        /// display availeble workers and can add workers 
        /// to service witjout exeeding limit and u can 
        /// update nb of workers
          if(selectedIndex == 0)...[
            Expanded(
              child:Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 100+(workersNames.length~/4)*30,
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                      color: informationColor100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children : [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                decoration: BoxDecoration(
                                  color: informationColor,
                                  borderRadius: BorderRadius.circular(6.0)
                                ),
                                child: Text("Nombre d'ouvrier affecter",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ),
                              SizedBox(width: 5,),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                                decoration: BoxDecoration(
                                  color: informationColor,
                                  borderRadius: BorderRadius.circular(6.0)
                                ),
                                child: Row(
                                  children: [
                                      Text("${workersNames.length}",
                                      style: TextStyle(
                                        color: alertColor100,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(" / ${service.nbWorkers}",
                                      style: TextStyle(
                                        color: primaryColor100,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                )
                            ),
                              Spacer(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        if(workers.length+workersNames.length>service.nbWorkers){
                                          service.nbWorkers++ ;
                                        }
                                        else{
                                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text("C'est le maximum des ouvries disponibles !"),
                                                backgroundColor : alertColor,
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: successColor600,
                                        borderRadius: BorderRadius.circular(60.0),
                                      ),
                                      child: Icon(Iconsax.add,color: Colors.white,size: 14,),
                                    ),
                                  ),
                                  SizedBox(width: 6,),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        if(service.nbWorkers<= workersNames.length){
                                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                content: Text("Il faut supprimer les ouvriers affecter d'abord !"),
                                                backgroundColor : alertColor,
                                                duration: Duration(seconds: 3),
                                              ),
                                            );
                                        }
                                        else if(service.nbWorkers>0){
                                          service.nbWorkers-- ;
                                        }
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: alertColor,
                                        borderRadius: BorderRadius.circular(60.0),
                                      ),
                                      child: Icon(Iconsax.minus,color: Colors.white,size: 14,),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 16,),
                          SizedBox(
                            height: workersNames.isEmpty ? 30 : 0,
                            child: FutureBuilder(
                              future: futureAffectedWorker,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                 if (snapshot.hasError) {
                                  return Center(child: Text("Error: ${snapshot.error}"));
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty ) {
                                  return  Center(child: Text("Aucun ouvrier affecté à ce service"));
                                }
                                workersNames = snapshot.data! ;
                                return SizedBox();},
                            ),
                          ),
                          SizedBox(
                            height: workersNames.isNotEmpty ? 30+(workersNames.length~/4)*35 : 0,
                            child: workersNames.isNotEmpty ?  GridView.builder(
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, 
                                  mainAxisSpacing: 5.0, 
                                  childAspectRatio: 4 / 1,
                                ),
                                itemCount:workersNames.length,
                                itemBuilder:(context, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 5.0),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                      decoration: BoxDecoration(
                                        color : Colors.white,
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 65,
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(workersNames[index].name,style: TextStyle(color: neutralColor300,fontSize: 10,fontWeight: FontWeight.bold,),)),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                workers.add(workersNames[index]);
                                                workersNames.removeAt(index);
                                              });
                                            },
                                            child: Icon(Icons.close,color: neutralColor100,size: 15,)
                                          )
                                        ],
                                      ),
                                    ),
                                  ) ;
                                  },
                                ): SizedBox(),
                          )
                        ],
                      ),
                    ),
                   
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child:  FutureBuilder(
                          future: futureWorkers, 
                          builder: (context,snapshot){
                            ////handling serveur delay or issue
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text("Error: ${snapshot.error}"));
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text("Aucun ouvrier disponible pour cette date"));
                              }

                              workers = snapshot.data! ;
                              return GridView.builder(
                                padding:EdgeInsets.all(16.0),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 2 items per row
                                  crossAxisSpacing: 16.0, // spacing between items horizontally
                                  mainAxisSpacing: 16.0, // spacing between items vertically
                                  childAspectRatio: 3 / 1, // Adjust the aspect ratio to suit the card layout
                                ),
                                itemCount: workers.isEmpty ? 1 : workers.length,
                                itemBuilder:(context, index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: informationColor100,
                                    ),
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 120,
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(workers[index].name,style: TextStyle(
                                              color: neutralColor600,
                                              fontSize: 14 ,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.5,
                                            ),),
                                          ),
                                        ),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              if(service.nbWorkers>workersNames.length){
                                                workersNames.add(workers[index]);
                                                workers.removeAt(index);
                                              }
                                              else{
                                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                    content: Text("Il faut augmenter le nombre d'ouvriers nécessaire !"),
                                                    backgroundColor : alertColor,
                                                    duration: Duration(seconds: 3),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          child: Icon(Iconsax.add_square5,color: informationColor300,size: 20,)
                                        )
                                      ],
                                    ),
                                  );
                                },) ;
                          })
                
              ),
            ),
          
                  ],
                ),
              ) ,
            ),
          ],

          if(selectedIndex == 1)...[

          ],

          if(selectedIndex == 2)...[
            
          ]
        ],
      ),
    );
  }
}