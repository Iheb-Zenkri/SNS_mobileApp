import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/components/dialog_widget.dart';
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
  
  final List<String> choices = ['Equipe','Gallery'];
  int selectedIndex = 0 ;
  
  List<Worker> workersNames = [];
  List<Worker> workers = [];
  List<Worker> initialWorker = [] ;
  late Future<List<Worker>> futureWorkers ;
  late Future<List<Worker>> futureAffectedWorker ;

  @override
   void initState() {
    super.initState();
    futureWorkers = ApiService().fetchWorkersByDate(widget.service.date);
    futureAffectedWorker = ApiService().getServiceWorker(widget.service.id);
    ApiService().getServiceWorker(widget.service.id).then((workerss){
      initialWorker = workerss ;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final service = widget.service ;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
            /// Header that conatains client name and feedbacks
            /// about which worker he needs and which he doesnt
            /// and the menu to affect new workers materiel or images
              Container(
                margin: EdgeInsets.only(top: 40.0),
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
                            onTap: (){
                              Navigator.pop(context);
                            },
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
                                        service.client.note??"Aucun Remarque",style: TextStyle(color: neutralColor,fontSize: 12,letterSpacing: 1.5),
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
                        itemCount: 2,
                        itemBuilder:(context, index) {
                          final bool isSelected = selectedIndex == index;
                          return GestureDetector(
                            onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                width: MediaQuery.sizeOf(context).width/2-16,
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
            /// to service without exeeding limit and u can 
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
                          height: 90+((workersNames.length-1)~/3 )*35,
                          padding: EdgeInsets.fromLTRB(15, 8, 15, 4),
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
                                                    duration: Duration(seconds: 2),
                                                  ),
                                                );
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: primaryColor300.withOpacity(0.9),
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
                                                    duration: Duration(seconds: 2),
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
                                            color: primaryColor300.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(60.0),
                                          ),
                                          child: Icon(Iconsax.minus,color: Colors.white,size: 14,),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height:45+((workersNames.length-1)~/3 )*35,
                                child: FutureBuilder(
                                  future: futureAffectedWorker,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: SizedBox(width: 15,height: 15, child: CircularProgressIndicator(strokeWidth: 1.0,)));
                                    }
                                     if (snapshot.hasError) {
                                      return Center(child: Text("Error: ${snapshot.error}"));
                                    }
                                    workersNames = snapshot.data! ;
                                    return  workersNames.isNotEmpty ?  
                                    GridView.builder(
                                      padding: EdgeInsets.only(top:12),
                                      scrollDirection: Axis.vertical,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3, 
                                          mainAxisSpacing: 10.0, 
                                          childAspectRatio: 4 / 1,
                                        ),
                                        itemCount:workersNames.length,
                                        itemBuilder:(context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(right: 6.0),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                              decoration: BoxDecoration(
                                                color : Colors.white,
                                                borderRadius: BorderRadius.circular(50.0),
                                              ),
                                              child: GestureDetector(
                                                    onTap: (){
                                                      setState(() {
                                                        workers.add(workersNames[index]);
                                                        workersNames.removeAt(index);
                                                      });
                                                    },
                                                    child:  Row(
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
                                                Icon(Icons.close,color: neutralColor100,size: 15,)
                                                ],
                                              ),
                                            ),
                                            ),
                                          ) ;
                                          },
                                        ): Center(child: Text("Aucun ouvrier affecté à ce service"));

                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 30),
                            child:  FutureBuilder(
                              future: futureWorkers, 
                              builder: (context,snapshot){
                                ////handling serveur delay or issue
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: SizedBox(height: 30,width: 30, child: CircularProgressIndicator(strokeWidth: 2.0,color: primaryColor,)));
                                  }
                                  if (snapshot.hasError) {
                                    return Center(child: Text("Erreur : Le serveur est en panne "));
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
                                        child: GestureDetector(
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
                                                        duration: Duration(seconds: 2),
                                                      ),
                                                    );
                                                  }
                                                });
                                              },
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 115,
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
                                              Icon(Iconsax.add_square5,color: informationColor300,size: 20,)
                                              ],
                                            ),
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
          
            ],
          ),
          
          Positioned(
            bottom: 0,
            left: (MediaQuery.sizeOf(context).width-200)/2,
            child: GestureDetector(
              onTap: (){
                String confirmMessage ="";
                if(selectedIndex == 0 ){
                  confirmMessage = " Êtes-vous sûr de vouloir Enregistrer l'Equipe pour le service ${service.type} de ${service.client.name.toUpperCase()} ?" ;
                }
                else{
                  confirmMessage = " Êtes-vous sûr de vouloir Enregistrer ces photos pour le service ${service.type} de ${service.client.name.toUpperCase()} ?" ;
                }
                showDialog(
                  context: context, 
                  builder:(context) {
                    return ConfirmWidget(confirmMessage: confirmMessage,onChange: (isOk) {
                      if(isOk){
                        selectedIndex == 0 ? sauvgardWorker() : sauvgardWPicture() ;
                      }
                    },);
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                width: 200,
                height: 45,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor600.withOpacity(0.3), 
                      offset: Offset(0,5), 
                      blurRadius: 30, 
                      spreadRadius: 3, 
                    ),
                  ]
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const[
                    Icon(Iconsax.document_forward5,size: 18,color: Colors.white,),
                    SizedBox(width: 6,),
                    Text("Enregistrer",style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2.0,
                    ),),
                  ],
                ),
              ),
            )),
        ],
      ),
    );
  }
  
  void sauvgardWorker() async {
    List<String> errorMessage = [] ;
    List<String> successMessage = [] ;
    
    for(var worker in workersNames){
      if(!initialWorker.contains(worker)){
        final response = await ApiService().addWorkerToService(widget.service.id, worker.id, widget.service.date);
        if(response.statusCode == 404){
          errorMessage = ["Le service ${widget.service.type} de ${widget.service.client.name} n'existe pas !"] ;
          break ;
        }
        else if(response.statusCode == 403 || response.statusCode == 400){
          errorMessage.add("L'Ouvrier ${worker.name.toUpperCase()} n'est plus disponible !");
        }
        else if(response.statusCode == 500){
          errorMessage.add("Un erreur se produit pendant l'ajout d'Ouvrier ${worker.name.toUpperCase()} !");
        }
        else if(response.statusCode == 200){
          successMessage.add("L'Ouvrier ${worker.name.toUpperCase()} a été AJOUTER au service avec succés !");
        }
      }
    }

    for(var previousWorker in initialWorker){
      if(!workersNames.contains(previousWorker)){
        await ApiService().deleteWorkerFromService(widget.service.id, previousWorker.id);
        successMessage.add("L'Ouvrier ${previousWorker.name.toUpperCase()} a été RETIRER de service avec succés !");
      }
    }

    if(successMessage.isNotEmpty){
      await  showDialog(
        context: context, 
        builder:(context) {
          return SuccessWidget(validationMessage: successMessage.join('\n'));
        },
      );
    }

    if(errorMessage.isNotEmpty){
      showDialog(
        context: context, 
        builder:(context) {
          return AlertWidget(errorMessage: errorMessage.join('\n'));
        },
      );
    }
  ApiService().getServiceWorker(widget.service.id).then((workerss){
      initialWorker = workerss ;
    });
  
  setState(() {
    widget.service.nbWorkers = workersNames.length ;
  });
  ApiService().updateService(widget.service);
  }
  
  void sauvgardWPicture() async {

  }

}