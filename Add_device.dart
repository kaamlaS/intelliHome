import 'package:flutter/material.dart';
import 'package:intellihome/main.dart';
import 'package:http/http.dart' as http;

class Add_device extends StatefulWidget {
  @override
  _Add_deviceState createState() => _Add_deviceState();
}

class _Add_deviceState extends State<Add_device> {
  bool _value1 = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar:  AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
            Navigator.pop(context);
          }),
          centerTitle: true,
          title: Text("Add device",style: TextStyle(color: Colors.yellow)),
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.yellow,opacity: 2.0,size: 3),
        ),
        body: DeviceForm(),
      ),
    );
  }
}


class DeviceForm extends StatefulWidget {
  @override
  _DeviceFormState createState() => _DeviceFormState();
}

class _DeviceFormState extends State<DeviceForm> {
  TextEditingController NameController, GroupController,CharacterController;
  final _FormKey = GlobalKey<FormState>();
  String DropDownStr;

  Future<bool> AddDevice() async {
    print(NameController.text);
    print(GroupController.text);
    print(CharacterController.text);
    if(GroupController.text != null){
    dynamic response = await http.get('http://13.229.231.75:5000/AddDevice?DeviceName='+NameController.text+"&Character="+CharacterController.text+'&GroupName='+GroupController.text);
    }
    else {
      dynamic response = await http.get('http://13.229.231.75:5000/AddDevice?DeviceName='+NameController.text+"&Character="+CharacterController.text);
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DropDownStr = "Red" ;
    NameController = TextEditingController() ;
    GroupController = TextEditingController() ;
    CharacterController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _FormKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: 60,
                width: 280,
                decoration:BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: NameController,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      enabled: true,
                      hintStyle: TextStyle(color: Colors.white),

                      hintText: "enter device name",

                    ),
                    textAlign: TextAlign.center,
                    validator: (value){
                      if(value.isEmpty){
                        return "enter a label for your switch";
                      }
                      return null;
                    },
                  ),
                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: 60,
                width: 280,
                decoration:BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: CharacterController,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      enabled: true,
                      hintStyle: TextStyle(color: Colors.white),


                      hintText: "enter one character",

                    ),
                    textAlign: TextAlign.center,
                    validator: (value){
                      if(value.isEmpty || value.length>1){
                        return "one character needed";
                      }
                      return null;
                    },
                  ),
                ),

              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Container(
                height: 60,
                width: 280,
                decoration:BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: GroupController,
                    decoration: InputDecoration(

                      focusColor: Colors.white,
                      enabled: true,
                      hintStyle: TextStyle(color: Colors.white),

                      hintText: "group name(optional)",
                    ),
                    textAlign: TextAlign.center,

                  ),
                ),
              ),
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              color: Colors.black12,
              onPressed: (){
                if(NameController != null && CharacterController != null && _FormKey.currentState.validate()) {
                  AddDevice();
                  NameController.clear();
                  GroupController.clear();
                  CharacterController.clear();
                }
              },
              child: Text("submit",style: TextStyle(color: Colors.white70)),
              padding: EdgeInsets.symmetric(horizontal: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}


