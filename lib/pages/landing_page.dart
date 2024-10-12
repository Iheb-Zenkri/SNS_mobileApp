import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badge;
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/pages/calendar_page.dart';
import 'package:sns_app/components/new_service.dart';
import 'package:sns_app/pages/location_detection.dart';
import 'package:sns_app/pages/location_page.dart';
import 'package:sns_app/pages/home_page.dart';
import 'package:sns_app/pages/team_page.dart';


class Homepage extends StatefulWidget{
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomePageState();  
}


class _HomePageState extends State<Homepage>{

    var counter = 10;

    var selectedIndex = 3;
        

    static const List<StatefulWidget> widgetOptions = <StatefulWidget>[
          AccueilPage(),
          CalendarPage(),
          LocationPage(),
          TeamPage(),
    ];

 void _showCreateServiceDialog(BuildContext context) async{
   await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ServicePopup();
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor100,
      resizeToAvoidBottomInset: false,
  // app bar 
      appBar: selectedIndex==0 ? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('A C C U E I L',style: TextStyle(color: primaryColor600,fontWeight:FontWeight.bold),) ,
        centerTitle: true,
        titleSpacing: 50,
        leading: Builder(
          builder: (context){
            return IconButton(
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Iconsax.menu_1),color: primaryColor600,);
          }),

        actions: [
          Padding(
            padding: EdgeInsets.only(right: 5.0),
            child:IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> LocationDetection()));
            },
            icon: badge.Badge(
                position: badge.BadgePosition.topEnd(top: -5, end: -6),
                showBadge: counter > 0,
                badgeContent: Text(
                  '$counter',
                  style: TextStyle(
                    fontSize: 8,
                    color: Colors.white,
                    fontWeight: FontWeight.w800
                  ),),
                badgeStyle: badge.BadgeStyle(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(5),
                ),
                child: Icon(Iconsax.notification,color: primaryColor600,),
              )
            ),
          )
          ],
      ) : null, 

  // menu drawer
      drawer: selectedIndex ==0 ? Drawer(
        child: Container(
          color: Colors.white,
          child: Stack(
            children:[ ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: const Text('Zenkri Iheb',style: TextStyle(color: Colors.white,letterSpacing: 2.0),),
                  accountEmail: const Text('+216 25240471',style: TextStyle(color: Colors.white,letterSpacing: 2.0)),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval( child: Image.asset('lib/icons/userpic.jpg'),),
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor,
              
                  ),
                ),
            
                ListTile(
                  leading: Icon(Iconsax.location),
                  title: Text('Services'),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Iconsax.location),
                  title: Text('Services'),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Iconsax.location),
                  title: Text('Services'),
                  onTap: (){},
                ),
            
                SizedBox(height: 20),
                
                ListTile(
                  leading: Icon(Iconsax.location),
                  title: Text('Services'),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Iconsax.location),
                  title: Text('Services'),
                  onTap: (){},
                ),
                
                SizedBox(height: 20),
            
                ListTile(
                  leading: Icon(Iconsax.location),
                  title: Text('Services'),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Iconsax.location),
                  title: Text('Services'),
                  onTap: (){},
                ),
              ],
            ),
                 Positioned(
                  top: 40,
                  right: 5,
                  child: IconButton(
                    icon: Icon(Iconsax.edit, color: Colors.white),
                    onPressed: () {
                    },
                  ),
                ),
            ],
            ),
          ),
        ) : null,
      
  // add button -> floating action button
    floatingActionButton: selectedIndex == 0 ? FloatingActionButton.small(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: (){
        _showCreateServiceDialog(context) ;
        
      },
      backgroundColor: informationColor,
      focusColor: informationColor300,
      child: Icon(Iconsax.add,color: informationColor100,),
    ) : null,

  // nav bar -> bottom navigation bar
      bottomNavigationBar: NavigationBarTheme(
        data : NavigationBarThemeData(
          indicatorColor: primaryColor300,
          elevation: 20,
          shadowColor: Colors.black,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ) ,
        
        child :NavigationBar(
              height: 60,
              backgroundColor: Colors.white,
              selectedIndex: selectedIndex,
              onDestinationSelected: onSelected,
              destinations: [
                        NavigationDestination(
                          icon: Icon(Iconsax.home,color : selectedIndex == 0? primaryColor100 : primaryColor),
                          label: 'Accueil',
                        ),
                        NavigationDestination(
                          icon: Icon(Iconsax.calendar,color : selectedIndex == 1? primaryColor100 : primaryColor),
                          label: 'Calendar',
                        ),
                        NavigationDestination(
                          icon: Icon(Iconsax.location,color : selectedIndex == 2? primaryColor100 : primaryColor),
                          label: 'Localisation',
                        ),
                        NavigationDestination(
                          icon: Icon(Iconsax.profile_2user,color : selectedIndex == 3? primaryColor100 : primaryColor),
                          label: 'Equipe',
                        ),
                ],
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            ),

  ),
  
     body: Center(
        child: widgetOptions[selectedIndex],
      ),
    );
  
  }
  
  
  void onSelected(int index) {
    setState(() {
      selectedIndex = index ;
    });
  }
}