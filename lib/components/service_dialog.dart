import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sns_app/components/Dialog_Widget.dart';
import 'package:sns_app/models/Client.dart';
import 'package:sns_app/models/Service.dart';
import 'package:sns_app/models/colors.dart';
import 'package:sns_app/models/data.dart';
import 'package:sns_app/pages/location_detection.dart';

class ServiceDialog extends StatefulWidget{

  final Service service;
  const ServiceDialog({super.key, required this.service});

  @override
  State<ServiceDialog> createState() => _ServiceDialog() ;
}

class _ServiceDialog extends State<ServiceDialog> {
  List<String> types = ['fin chantier', 'menage','gardin', 'cleaning','autre'] ;
  
  String? _typeController = "";
  String _dateController = "";
  String _timeController = "";
  String townName = "Chargement..." ;
  final TextEditingController _nbWorkersController = TextEditingController(text: '0');
  final TextEditingController _estimatedPriceController = TextEditingController(text: '0.00');
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  List<double> coordinates = [];
  bool? _equipment = false;

  bool _ISUPDATE = false ;

@override
  void dispose(){
    _nbWorkersController.dispose();
    _estimatedPriceController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    coordinates = widget.service.location.coordinates ;
    _fetchTownName();
  }
  Future<void> _fetchTownName() async {
    try {
      final name = await widget.service.location.getLocationName();
      if(!mounted) return;
      setState(() {
        townName = name;
      });
    } catch (e) {
      setState(() {
        townName = 'Djerba';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var service = widget.service ;
    if (!types.contains(service.type)){types.add(service.type);}

      return Dialog(
        insetAnimationCurve: Curves.bounceInOut,
        insetAnimationDuration: Duration(milliseconds: 400),
        insetPadding: EdgeInsets.all(15),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                          service.client.name.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),),
                    ],
                  ),
                      Row(
                        children: [
                          Icon(Iconsax.call5,color: Colors.white,size: 14,),
                          SizedBox(width: 4,),
                          Text(
                          '${service.client.phoneNumber.substring(0,2)} ${service.client.phoneNumber.substring(2,5)} ${service.client.phoneNumber.substring(5)}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.5,
                          ),),
                        ],
                      ),
                ],
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
                  height: MediaQuery.sizeOf(context).height*0.66,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),  
        
                        ///Modification that appear in update
                        if(_ISUPDATE)...[
                          Row(
                            children: [
                              Container(height: 1,width: 20,color: neutralColor100,),
                              Text("  Modifier Client  ",style: TextStyle(color: neutralColor200),),
                              Container(height: 1,width: 190,color: neutralColor100,),
                            ],
                          ),
                          SizedBox(height: 20,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 170,
                                height: 50,
                                child: TextField(
                                  controller: _nameController,
                                  keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                        labelText: "Nom de Client",
                                        labelStyle: TextStyle(
                                          fontSize: 12,
                                          letterSpacing: 1.5,
                                          color: neutralColor200,
                                          fontWeight: FontWeight.bold
                                        ),
                                        filled: true,
                                        fillColor: colorFromHSV(220, 0.06, 1),
                                        suffixIcon: Icon(Icons.person,size: 18,color: primaryColor,),
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
                                width: 140,
                                height: 50,
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.number,
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
                                ),
                              ),
                              ],
                          ),
                          SizedBox(height: 30,),
                          Row(
                            children: [
                              Container(height: 1,width: 20,color: neutralColor100,),
                              Text("  Modifier Service  ",style: TextStyle(color: neutralColor200),),
                              Container(height: 1,width: 185,color: neutralColor100,),
                            ],
                          ),
                          SizedBox(height: 20,),
                        ],
        
                      ///Main content to display data and update it
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
                                      value: _ISUPDATE ? _typeController : service.type,
                                      onChanged: _ISUPDATE ? (newValue){
                                      setState(() {
                                            _typeController = '$newValue';
                                      });
                                      } : null ,
                                      items: types.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList() ,                                          
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
                                        if(_ISUPDATE){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> LocationDetection(location: coordinates,))).then((value){
                                              if(value != null ){
                                                coordinates = [];
                                                coordinates.add(value.latitude);
                                                coordinates.add(value.longitude);
                                              }
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
                                          Text(townName),
                                          Icon(Iconsax.location,size: 20,color: informationColor,),                               
                                        ],
                                      )
                                    ),
                                  )
                                  ],
                              ),
                          ],
                        ),
                        SizedBox(height: 30,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 50,
                              child: TextField(
                                controller: _ISUPDATE ? _nbWorkersController : TextEditingController(text: '${service.nbWorkers}'),
                                keyboardType: TextInputType.number,
                                readOnly: !_ISUPDATE,
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
                                controller: _ISUPDATE ? _estimatedPriceController : TextEditingController(text: '${service.estimatedPrice}'),
                                keyboardType: TextInputType.number,
                                readOnly: !_ISUPDATE,
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
                        SizedBox(height: 15,),
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
                                    onTap: _ISUPDATE ? () async {
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
                                        } : null ,
                                    
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
                                          Text(_ISUPDATE ? _dateController : service.date),
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
                                    onTap: _ISUPDATE ? () async {
                                        final TimeOfDay? timeOfDay = await showTimePicker(
                                          context: context, 
                                          initialTime: TimeOfDay(hour: 8, minute: 00),
                                          initialEntryMode: TimePickerEntryMode.inputOnly,
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
                                    } : null,
                    
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
                                          Text(_ISUPDATE ? _timeController : service.time),
                                          Icon(Iconsax.clock,size: 20,color: informationColor,),
                                        ],
                                      )
                                    ),
                                  )
                                  ],
                              ),
                          ],
                        ),       
                        SizedBox(height: 25,),
                        SizedBox(
                            width: 280,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                Text("Service avec Matériel",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: informationColor600,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0
                              ),),
                              Container(
                                padding: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: informationColor100,width: 1,),
                                  color: colorFromHSV(220, 0.04, 1),    
                                ),
                                child: Checkbox(
                                  value: _ISUPDATE ? _equipment : service.equipment,
                                  tristate: false,
                                  activeColor: informationColor,
                                  onChanged:_ISUPDATE ? (newBool){
                                  setState(() {
                                  _equipment = newBool ;
                                  });
                                  } : null ,
                                ),
                              ),
                              ],
                            ),
                          ),
                        if(!_ISUPDATE)...[
                          SizedBox(height: 25,),
                          Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              GestureDetector(
                                  onTap: (){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertWidget(errorMessage: 'Êtes-vous sûr de vouloir supprimer ce service ?',isFooter: true,
                                          onChange: (isOk) async {
                                            if(isOk){
                                              deleteService(service); 
                                              Navigator.of(context).pop();                                            
                                              }
                                          });
                                        });
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 45,
                                    alignment: Alignment.center,
                                    //padding: EdgeInsets.symmetric(horizontal: 35,vertical: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.0),
                                      color: alertColor,
                                    ),
                                    child: Center(
                                      child: Text("Supprimer",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0
                                      ),),
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _typeController = service.type;
                                      _nbWorkersController.text = '${service.nbWorkers}' ;
                                      _estimatedPriceController.text = '${service.estimatedPrice}' ;
                                      _equipment = service.equipment ;
                                      _dateController = service.date ;
                                      _timeController = service.time.replaceAll(':', ' : ');
                                      _phoneController.text = service.client.phoneNumber ;
                                      _nameController.text = service.client.name ;
                                      _ISUPDATE = !_ISUPDATE ;
                                    });
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 120,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.0),
                                      color: informationColor,
                                    ),
                                    child: Center(
                                      child: Text("Modifier",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0
                                      ),),
                                    ),
                                  ),
                                )
                            ],
                          ),
                            ],                        
                      ///Modification that appear in update
                        if(_ISUPDATE)...[
                          SizedBox(height: 30,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      _ISUPDATE = !_ISUPDATE ;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.0),
                                      color: alertColor,
                                    ),
                                    child: Center(
                                      child: Text("Annuler",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0
                                      ),),
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                  onTap: (){
                                    showDialog(
                                      context: context, 
                                      builder: (BuildContext context){
                                        return ConfirmWidget(confirmMessage: "Êtes-vous sûr d'enregistrer les modifications dans ce service ?",
                                          onChange: (isOk) async {
                                            if(isOk){
                                              updateService(service);
                                              Navigator.of(context).pop();       
                                            }
                                          });
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14.0),
                                      color: successColor600,
                                    ),
                                    child: Center(
                                      child: Text("Enregistrer",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0
                                      ),),
                                    ),
                                  ),
                                ),
                              
                            ],
                          )
                        ],
                        SizedBox(height: 20,),
                      ],
        
                    ),
                  ),
                            ),
            ],
          ),
      );
  }
  
  void updateService(Service service) {
        setState(() {
          service.type = _typeController ?? service.type ;
          service.nbWorkers = int.tryParse(_nbWorkersController.text) ?? service.nbWorkers;
          service.estimatedPrice = double.tryParse(_estimatedPriceController.text) ?? service.estimatedPrice;
          service.date = _dateController ;
          service.time = _timeController.replaceAll(' ', '') ;
          service.equipment = _equipment ?? service.equipment ;
          service.location.coordinates = coordinates ;
        });

    /// update le client 
    if(service.client.name != _nameController.text || service.client.phoneNumber != _phoneController.text){
        final Client client = Client(
                                id: service.client.id, 
                                name: _nameController.text, 
                                phoneNumber: _phoneController.text,
                                isDeleted: false);
        ApiService().updateClient(client)
          .then((response) {
              setState(() {
              if (response.statusCode == 200 || response.statusCode == 201) {
                ApiService().updateService(service).then((response) {
                  setState(() {
                        if (response.statusCode == 200 || response.statusCode == 201) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SuccessWidget(validationMessage: 'Client et Service a été modifier avec succés !' ,);
                              },
                            );
                            _ISUPDATE = !_ISUPDATE ;
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertWidget(errorMessage: 'Échec de la mise à jour du Service. Veuillez réessayer.' );
                              },
                            );
                        }
                    });
                });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertWidget(errorMessage: 'Échec de la mise à jour du client. Veuillez réessayer : $response' );
                    },
                  );
              }
          });
        });
    }
    else{
      ApiService().updateService(service).then((response) {
         setState(() {
              if (response.statusCode == 200 || response.statusCode == 201) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SuccessWidget(validationMessage: 'Service a été modifier avec succés !' ,);
                    },
                  );
                  _ISUPDATE = !_ISUPDATE ;
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertWidget(errorMessage: 'Échec de la mise à jour du Service. Veuillez réessayer.' );
                    },
                  );
              }
          });
      });
    }
      
  }
 
  void deleteService(Service service){
    ApiService().deleteService(service.id).then((response) {
         setState(() {
              if (response.statusCode == 200 || response.statusCode == 201) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SuccessWidget(validationMessage: 'Service a été supprimer avec succés !' ,);
                    },
                  );
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertWidget(errorMessage: 'Échec de la suppression du Service. Veuillez réessayer.' );
                    },
                  );
              }
          });
      });
    
  }
}