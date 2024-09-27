import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sns_app/models/colors.dart';

class AffectationService extends StatefulWidget{
  const AffectationService({super.key});

  @override
  State<AffectationService> createState() => _AffectationService() ;
}

class _AffectationService extends State<AffectationService>{
  
  final List<String> choices = ['Equipe','Matériel','Gallery'];
  int selectedIndex = 0 ;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Column(
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
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
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