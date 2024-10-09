import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/components/Dialog_Widget.dart';
import 'package:sns_app/models/Client.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';
import 'package:sns_app/pages/location_detection.dart';

class ServicePopup extends StatefulWidget {
  const ServicePopup({super.key});

  @override
  State<ServicePopup> createState() => _ServicePopup();
}

class _ServicePopup extends State<ServicePopup> {

  late int _clientIdController = -1 ;

  final PageController _pageController = PageController() ;
  
  void _updateId(int id){
    setState(() {
      _clientIdController = id ;
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
    void dispose() {
      _pageController.dispose();
      super.dispose();
    }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.only(top: 25,left: 15,right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            color: informationColor600,
            ),
            child: Center(
              child: Text(
                  "NOUVEAU SERVICE",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),),
            ),
          ),
              
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              color: Colors.white
            ),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height*0.6,
            child: PageView(
              controller: _pageController,
              //physics: _clientIdController > 0 ? ScrollPhysics(): NeverScrollableScrollPhysics(),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AddClientPage(setId : _updateId),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if(_clientIdController > 0){
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xffeaebec),
                            ),
                            child: Icon(Iconsax.arrow_right_3,size: 20,)
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AddServicePage(id: _clientIdController),
                    ],
                ),
              ],
            ),
          ),
        ],
      ),
       );
  }

}

// ADD CLIENT WIDGET
class AddClientPage extends StatefulWidget{
  final void Function(int) setId ;
  const AddClientPage({super.key, required this.setId});

  @override
  State<AddClientPage> createState() => _AddClientPage(); 
}
class _AddClientPage extends State<AddClientPage> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false ;
  bool _isnew = false ;


  List<Client> _allResults =[];
  List<String> _searchResults = [];

 
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    ApiService().fetchAllClients().then((client) => _allResults.addAll(client));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isNotEmpty && !_isnew) {
        _isSearching = true;
        _searchResults = _allResults.map((client) => client.name)
            .where((client) => client.toLowerCase().contains(query)).toList();

      } else {
      _searchResults = _allResults.map((client) => client.name).toList();
        _isSearching = false ;
      }
    });
  }
   
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Construct the payload
      final client = Client(id: 0,
            name: _nameController.text,
            phoneNumber: _phoneController.text
          );

      ApiService().createClient(client).then((response) =>{
        setState(() async {
          if (response.statusCode == 200 || response.statusCode == 201) {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SuccessWidget(validationMessage:'Client a été créé avec succés !' ,);
                },
              );
              _isnew = false ;
              _searchController.text = _nameController.text ;
              _allResults.add(client);
              widget.setId(Client.fromJson(jsonDecode(response.body)).id);
          }else {
              String errorMessage = "";
            if (response.statusCode == 400) {
              errorMessage = "Le Nom ou le Téléphone de client existe déja";
            } else{
              errorMessage = 'Échec de la création du client. Veuillez réessayer.' ;
            }
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertWidget(errorMessage: errorMessage,);
                },
              );
          }
        }),
      }) ;
    }
  }

   @override
     Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            if(!_isnew)...[       
            //search existed client
           _isnew ? SizedBox(height: 10,): SizedBox(height: 20,),
            Row(
              children: [
                Text(
                  "  CHERCHER",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 18,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                    color: informationColor600,
                  ),),
                  Text(
              " un client",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 2.0,
                fontWeight: FontWeight.normal,
                color: informationColor700,
              ),),
              ],
            ),
              const SizedBox(height: 10,),
        
              TextField(
                controller: _searchController,
                readOnly: _isnew,
                decoration: InputDecoration(
                  filled: false,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: primaryColor,width: 1,),
                    gapPadding: 0,
                  ),
                  hintText: "ex: foulen fouleni",
                  hintStyle: TextStyle(
                     fontSize: 12,
                  letterSpacing: 1.5,
                  color: neutralColor200,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito'
                  ),
                  prefixIcon: const Icon(Iconsax.search_normal_14,size: 18,),
                  prefixIconColor: primaryColor,
                ),
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  color: neutralColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Nunito'
                ),
              ),
           _isnew ? SizedBox(height: 15,): SizedBox(height: 50,),
          //create new client
            Center(
              child: CustomPaint(
                painter: DashedBorderPainter(),
                child: Container(
                  height: 150,
                  width: 280,
                  color: informationColor100,
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Créer un nouveau Client",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                          color: primaryColor600,
                        ),),
                          
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: informationColor300,
                          ),
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                _isnew = true ;
                              });
                            },
                            child: Icon(Iconsax.add,size: 25,color: primaryColor100, ))
                          ),
                    ],
                  ),
                ),
              ),
            ),
            ],
            if(_isnew)...[
              Container(
                height: 350,
                width: 300,
                padding: EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                                Text(
                                "Nouveau ",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.normal,
                                  color: neutralColor200,
                                ),),
                                Text(
                                  "CLIENT",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22,
                                    letterSpacing: 3.0,
                                    fontWeight: FontWeight.bold,
                                    color: informationColor600,
                                  ),),
                          ],
                        ),
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          labelText: "Nom de Client",
                          focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor,width: 1.5,),
                                gapPadding: 2.0,
                              ),
                          enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color:informationColor100,width: 1,),
                                gapPadding: 0,
                              ),
                          labelStyle: TextStyle(
                              fontSize: 12,
                            letterSpacing: 1.5,
                            color: neutralColor200,
                            fontWeight: FontWeight.bold
                          ),
                          filled: true,
                          fillColor: colorFromHSV(220, 0.06, 1),
                          suffixIcon: Icon(Icons.person_rounded,size: 20,color: primaryColor,)
                        ),
                        style:  TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.5,
                          color: primaryColor700,
                          fontWeight: FontWeight.bold
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le nom du client';
                          }
                          return null;
                        },
                                    ),
                  
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Téléphone",
                          labelStyle: TextStyle(
                              fontSize: 12,
                            letterSpacing: 1.5,
                            color: neutralColor200,
                            fontWeight: FontWeight.bold
                          ),
                          filled: true,
                          fillColor: colorFromHSV(220, 0.06, 1),
                          suffixIcon: Icon(Iconsax.call5,size: 18,color: primaryColor,),
                          focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor,width: 1.5,),
                                gapPadding: 2.0,
                              ),
                          enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor100,width: 1,),
                                gapPadding: 0,
                              ),
                        ),
                        style:  TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.5,
                          color: primaryColor700,
                          fontWeight: FontWeight.bold
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer le Téléphone du client';
                          }
                          return null;
                        },
                      ),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                _isnew = false ;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20,8,20,8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: alertColor,
                              ),
                              child: Text("Cancel",style: TextStyle(fontSize: 14,color:Colors.white),),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                                  _submitForm();
                            },
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20,8,20,8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: informationColor,
                              ),
                              child: Text("Créer",style: TextStyle(fontSize: 14,color:Colors.white),),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]
          ],
        ),
        if(_isSearching && !_isnew)...[
                Positioned(
                  left: -10,
                  right: -10,
                  top:110,
                  child: Container(
                    height: 250,
                    width:  MediaQuery.sizeOf(context).width,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Color(0xffffffff),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      itemBuilder:(context, index){
                        return GestureDetector(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 15),
                            decoration: BoxDecoration(
                              border: Border(bottom:BorderSide(color: neutralColor100),
                            )
                            ),                            
                            child: Row(
                              children: [
                                SizedBox(width: 10,),
                                Icon(Iconsax.user4,size: 16,color: informationColor200,),
                                SizedBox(width: 15,),
                                Text(
                                  _searchResults[index],
                                  style: TextStyle(
                                     fontSize: 14,
                                    letterSpacing: 1.5,
                                    color: informationColor700,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Nunito'
                                  ),
                                  ),
                              ],
                            ),
                          ),
                            onTap: (){
                              _searchController.text = _searchResults[index];
                              widget.setId(_allResults.firstWhere((client) => client.name ==_searchController.text).id);
                              _isSearching = false ;
                            },
                        );
                      },
                    ),
                  )
                )
              ],
      ],
    );
  }
}

// ADD SERVICE WIDGET
class AddServicePage extends StatefulWidget{
  final int id;
  
  const AddServicePage({super.key, required this.id});

  @override
  State<AddServicePage> createState() => _AddServicePage(); 
}
class _AddServicePage extends State<AddServicePage>{

  List<String> types = ['fin chantier', 'menage','gardin', 'autre'] ;
  
  String? _typeController ;
  String _dateController = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _timeController = "${TimeOfDay.now().hour.toString().padLeft(2, '0')} : ${TimeOfDay.now().minute.toString().padLeft(2, '0')} : 00";
  final TextEditingController _nbWorkersController = TextEditingController(text: '1');

  final TextEditingController _estimatedPriceController = TextEditingController(text: '0.00');
  bool? _equipment = false;
  List<double> coordinates = [] ;
  
@override
  void dispose(){
    _nbWorkersController.dispose();
    _estimatedPriceController.dispose();
    super.dispose();
  }
@override
  Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
        child: SizedBox( 
          width: MediaQuery.sizeOf(context).width,
          height: 355,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" Type",
                        style: TextStyle(
                          fontSize: 16,
                          color: informationColor600,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0
                      ),),
                      SizedBox(height: 4.0,),
                      Container(
                        width: 150,
                        padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                        decoration: BoxDecoration(
                          color: colorFromHSV(220, 0.04, 1),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color:informationColor100,width: 1,),
                        ),
                        child: DropdownButton(
                          hint: Text("Type de Service"),
                          icon: Icon(Iconsax.arrow_down_1,size: 15,color: primaryColor,),
                          dropdownColor: colorFromHSV(220, 0.01, 1),
                          isExpanded: true,
                          elevation: 0,
                          style: TextStyle(
                            color: primaryColor700,
                            fontSize: 14,
                          ),
                          underline: SizedBox(),
                          value: _typeController,
                           onChanged: (newValue){
                            setState(() {
                              _typeController = newValue;
                            });
                          }, 
                          items: types.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),                
                        ),
                      ),
                    ],
                  ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" Localisation",
                        style: TextStyle(
                          fontSize: 16,
                          color: informationColor600,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0
                      ),),
                      SizedBox(height: 4.0,),
                       GestureDetector(
                          onTap: () async {
                           Navigator.push(context, MaterialPageRoute(builder: (context)=> LocationDetection())).then((value){
                              if(value != null ){
                                coordinates.add(value.latitude);
                                coordinates.add(value.longitude);
                              }
                           });
                          },
                        child: Container(
                          width: 150,
                          height: 50,
                          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                          decoration: BoxDecoration(
                            color: colorFromHSV(220, 0.04, 1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color:informationColor100,width: 1,),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(""),
                              Icon(Iconsax.location,size: 20,color: informationColor,),                               
                            ],
                          )
                        ),
                      )
                       ],
                  ),
               
               ],
             ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 50,
                  child: TextField(
                    controller: _nbWorkersController,
                    keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Nb d'Ouvrier",
                          labelStyle: TextStyle(
                             fontSize: 12,
                            letterSpacing: 1.5,
                            color: neutralColor200,
                            fontWeight: FontWeight.bold
                          ),
                          filled: true,
                          fillColor: colorFromHSV(220, 0.06, 1),
                          suffixIcon: Icon(Iconsax.profile_2user5,size: 18,color: primaryColor,),
                          focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor,width: 1.5,),
                                gapPadding: 2.0,
                              ),
                          enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor100,width: 1,),
                                gapPadding: 0,
                              ),
                        ),
                        style:  TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.5,
                          color: primaryColor700,
                          fontWeight: FontWeight.bold
                        ),
                  ),
                ),
                 SizedBox(
                  width: 150,
                  height: 50,
                  child: TextField(
                    controller: _estimatedPriceController,
                    keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Devis",
                          labelStyle: TextStyle(
                             fontSize: 12,
                            letterSpacing: 1.5,
                            color: neutralColor200,
                            fontWeight: FontWeight.bold
                          ),
                          filled: true,
                          fillColor: colorFromHSV(220, 0.06, 1),
                          suffixIcon: Icon(Iconsax.coin_15,size: 18,color: primaryColor,),
                          focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor,width: 1.5,),
                                gapPadding: 2.0,
                              ),
                          enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: informationColor100,width: 1,),
                                gapPadding: 0,
                              ),
                        ),
                        style:  TextStyle(
                          fontSize: 14,
                          letterSpacing: 1.5,
                          color: primaryColor700,
                          fontWeight: FontWeight.bold
                        ),
                  ),
                ),
                
                ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" Date",
                        style: TextStyle(
                          fontSize: 16,
                          color: informationColor600,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0
                      ),),
                      SizedBox(height: 4.0,),
                      GestureDetector(
                              onTap: () async {
                                  final DateTime? dateTime = await showDatePicker(
                                    context: context, 
                                    firstDate: DateTime(2024), 
                                    lastDate: DateTime(2030),
                                    initialEntryMode: DatePickerEntryMode.calendarOnly,
                                    
                                    builder: (BuildContext context, Widget? child) {
                                    return Theme(
                                      data: ThemeData.light().copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: informationColor, // Header background color
                                          onPrimary: Colors.white, // Header text color
                                          onSurface: informationColor600, // Body text color
                                        ),
                                        dialogBackgroundColor: Colors.white, // Background color of the picker
                                      ),
                                      child: child!,
                                    );
                                  },
                                    );
                                    if(dateTime != null){
                                      setState(() {
                                        _dateController = DateFormat('yyyy-MM-dd').format(dateTime);
                                      });
                                    }
                              },
                            child: Container(
                              width: 150,
                              height: 50,
                              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                              decoration: BoxDecoration(
                                color: colorFromHSV(220, 0.04, 1),
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color:informationColor100,width: 1,),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_dateController),
                                  Icon(Iconsax.calendar_add,size: 20,color: informationColor,),
                                ],
                              )
                            ),
                          )
                       ],
                  ),
                 Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" Temps",
                        style: TextStyle(
                          fontSize: 16,
                          color: informationColor600,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0
                      ),),
                      SizedBox(height: 4.0,),
                       GestureDetector(
                          onTap: () async {
                              final TimeOfDay? timeOfDay = await showTimePicker(
                                context: context, 
                                initialTime: TimeOfDay(hour: 8,minute: 0),
                                initialEntryMode: TimePickerEntryMode.inputOnly,
                                barrierDismissible: false,
                                builder: (BuildContext context, Widget? child) {
                                  return Theme(
                                    data: ThemeData.light().copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: informationColor, // Header background color
                                        onPrimary: Colors.white, // Header text color
                                        onSurface: informationColor600, // Body text color
                                      ),
                                      dialogBackgroundColor: Colors.white, // Background color of the picker
                                    ),
                                    child: MediaQuery(
                                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                      child: child!,
                                    ),
                                  );
                                },
                              );
                                
                                if(timeOfDay != null){
                                  setState(() {
                                   _timeController = "${timeOfDay.hour.toString().padLeft(2, '0')} : ${timeOfDay.minute.toString().padLeft(2, '0')} : 00";
                                  });
                                }
                          },
                        child: Container(
                          width: 150,
                          height: 50,
                          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                          decoration: BoxDecoration(
                            color: colorFromHSV(220, 0.04, 1),
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color:informationColor100,width: 1,),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_timeController),
                              Icon(Iconsax.clock,size: 20,color: informationColor,),
                            
                             
                            ],
                          )
                        ),
                      )
                       ],
                  ),
                 
               ],
             ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    width: 120,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: informationColor100,width: 1,),
                      color: colorFromHSV(220, 0.04, 1),    
                    ),
                    child: Row(
                      children: [
                      Checkbox(
                        value: _equipment,
                        tristate: false,
                        activeColor: informationColor,
                        onChanged: (newBool){
                          setState(() {
                          _equipment = newBool ;
                          });
                        }),
                        Text("Materiel",
                        style: TextStyle(
                          fontSize: 14,
                          color: informationColor600,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0
                      ),),
                      ],
                    ),
                  ),
                GestureDetector(
                    onTap: () async {
                    await createService().then((onValue){
                      if(onValue){
                        Navigator.of(context).pop();  
                      }
                     }        
                    );                                   
                    },
                    child: Container(
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        color: informationColor,
                      ),
                      child: Center(
                        child: Text("Ajouter",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0
                        ),),
                      ),
                    ),
                  )
              ],
            )
            ],
          ),
        ),
      );
  }
  
  Future<bool> createService() async {
    final service = Service(
      id: 0,
      date: _dateController,
      type: _typeController ?? "autre",
      time: _timeController.replaceAll(' ', ''),
      location: Location(coordinates : coordinates),
      nbWorkers: int.tryParse(_nbWorkersController.text) ?? 0,
      nbDays: 1,
      equipment: _equipment ?? false,
      estimatedPrice: double.tryParse(_estimatedPriceController.text) ?? 0.0,
      finished: false,
      client: Client(id: widget.id, phoneNumber: "", name: ""),
    );

    try {
      final response = await ApiService().createService(service);
      if (response.statusCode == 200 || response.statusCode == 201) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return SuccessWidget(validationMessage: 'Service a été créé avec succès !');
          },
        );
      return true; 
      } else {
        // Show failure dialog
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertWidget(errorMessage: 'Échec de la création du Service. Veuillez réessayer.');
          },
        );
        return false; // Return false on failure
      }
    } catch (e) {
      // Handle exceptions
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertWidget(errorMessage: 'Une erreur est survenue. Veuillez réessayer.');
        },
      );
      return false; // Return false on error
    }
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 7.0;
    double dashSpace = 3.0;
    final paint = Paint()
      ..color = informationColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var path = Path();

    // Top side
    double startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, 0);
      startX += dashWidth;
      path.lineTo(startX, 0);
      startX += dashSpace;
    }

    // Right side
    double startY = 0;
    while (startY < size.height) {
      path.moveTo(size.width, startY);
      startY += dashWidth;
      path.lineTo(size.width, startY);
      startY += dashSpace;
    }

    // Bottom side
    startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, size.height);
      startX += dashWidth;
      path.lineTo(startX, size.height);
      startX += dashSpace;
    }

    // Left side
    startY = 0;
    while (startY < size.height) {
      path.moveTo(0, startY);
      startY += dashWidth;
      path.lineTo(0, startY);
      startY += dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}