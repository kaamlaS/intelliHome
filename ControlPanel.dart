import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intellihome/Add_device.dart';
import 'package:intellihome/Add_group.dart';
import 'dart:convert';


class ControlPanel extends StatefulWidget {

  @override
  _ControlPanelState createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {


  bool _value1 = false;
  Future<http.Response> _findgroups;
  List<Device> Switches = [];
  Device a,b;
  Future<List<Device>> _findswitches;
  int n=0;


  Future<bool>turnAllOffURL() async{
    dynamic response = http.get('http://13.229.231.75:5000/TurnAllOff');
    return false;
  }


  Future<bool>turnAllOnURL() async{
    dynamic response = http.get('http://13.229.231.75:5000/TurnAllOn');
    return true;
  }


  Future<http.Response> findGroupsToMap() async {
    dynamic response = await http.get('http://13.229.231.75:5000/FindGroupsToMap');
    print(response.body);
    return response;
  }


  Future<List<Device>>FindSwitches() async{
    var response = await http.get('http://13.229.231.75:5000/FindSwitches');
    print("abc");
    var switches = json.decode(response.body);

    for (var x in switches){
      Device device = Device(x['DeviceName'],x['Character'],x['count'],x['GroupName']);
      Switches.add(device);
    }
    print(Switches);
    return Switches;
  }


  @override
  void initState() {
    // TODO: implement initState
    _findgroups = findGroupsToMap();
    _findswitches = FindSwitches();
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 1,
                fit:FlexFit.loose,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child:
                        Text("Control Panel",style: TextStyle(color: Colors.yellow,fontSize: 50.0)),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        height: 50,
                        width:  300,
                        child: SwitchListTile(
                            value: _value1,
                            title: Text("turn off/on all devices",style: TextStyle(color: Colors.white)),
                            inactiveThumbColor: Colors.yellow,
                            activeColor: Colors.yellow,
                            onChanged: (bool value){
                              setState(() {
                                turnAllOffURL();
                                _value1 = value;
                                print(_value1);
                                if(_value1 == true){
                                  turnAllOnURL();
                                }
                              });
                            }),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child:  Column(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              height: 40,
                              width: 120,
                              child: RaisedButton(
                                color: Colors.black26,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                onPressed: (){
                                  print("abc");
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> new Add_group()));
                                },
                                child: Text("Add Group",style: TextStyle(color: Colors.white70)),
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              height: 40,
                              width: 120,
                              child: RaisedButton(
                                color: Colors.black26,
                                shape: new RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                ),
                                onPressed: (){
                                  print("abc2");
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> new Add_device()));
                                },
                                child: Text("Add new device",style: TextStyle(color: Colors.white70)),
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    FutureBuilder(
                      future: _findgroups,
                      builder: (BuildContext context,AsyncSnapshot snapshot) {
                        if(snapshot.hasData){
                          List l = json.decode(snapshot.data.body);
                          return Flexible(
                            fit: FlexFit.loose,
                            flex:30,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.loose,
                                  child: ListView.builder(
                                    itemCount: l.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return GroupItem(l[index]);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        else {
                          return Center(
                            child: Container(
                              child: CircularProgressIndicator(strokeWidth: 8.0),
                              height: 100,
                              width: 100,
                              padding: EdgeInsets.only(top: 16.0),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Text("Most Used Switches: ",style: TextStyle(fontSize: 18.0,color: Colors.yellow),textAlign: TextAlign.left),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Flexible(
                      flex:4,
                      fit: FlexFit.loose,
                      child: FutureBuilder(
                        future: _findswitches,
                        builder:(BuildContext context,AsyncSnapshot snapshot) {
                          if(snapshot.hasData){
                            dynamic count = snapshot.data.length;
                            dynamic count1 = (count/2).toInt();
                            print(count1);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Flexible(
                                  flex: 2,
                                  fit: FlexFit.loose,
                                  child: ListView.builder(
                                    itemCount: count1,
                                    itemBuilder: (BuildContext context, int index) {
                                      a = snapshot.data[n];
                                      b = snapshot.data[n+1];
                                      n =n+2;
                                      print(index);
                                      return SwitchItems(a,b);
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                          else {
                            return Center(
                              child: Container(
                                child: CircularProgressIndicator(strokeWidth: 10.0),
                                height: 100,
                                width: 100,
                                padding: EdgeInsets.only(top: 16.0),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Device {
  final String deviceName;
  String groupName;
  int count;
  final String character;

  Device(this.deviceName, this.character,this.count, this.groupName);
  Device.device1(this.deviceName,this.character,this.count);
}

class GroupItem extends StatefulWidget {
  String g;

  GroupItem(this.g);
  @override
  _GroupItemState createState() => _GroupItemState(g);
}

class _GroupItemState extends State<GroupItem> {
  String groupName;
  bool _value3 = false;

  _GroupItemState(this.groupName);

  Future<bool>turnoffgroup() async{
    print(groupName);
    dynamic response = http.get('http://13.229.231.75:5000/TurnGroupoff?GroupName='+groupName);
    return true;
  }

  Future<bool>IncGroup() async{
    print(groupName);
    dynamic response = http.get('http://13.229.231.75:5000/IncGroup?GroupName='+groupName);
    return true;
  }
  Future<bool>DeleteGroup() async{
    print('bro');
    dynamic response = await http.get('http://13.229.231.75:5000/DeleteGroup?GroupName='+groupName);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                child: InkWell(
                  child: Container(
                    decoration:BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    height: 60,
                    child: SwitchListTile(
                        value: _value3,
                        title: Text(groupName,style: TextStyle(color: Colors.white)),
                        inactiveThumbColor: Colors.yellow,
                        activeColor: Colors.yellow,
                        onChanged: (bool value){
                          setState(() {

                            print(_value3);
                            turnoffgroup();
                            _value3 = value;
                            if(_value3 == true){
                              IncGroup();
                            }
                          });
                        }),
                  ),
                  onLongPress: (){
                    showDialog(context:context, builder: (context){
                      return AlertDialog(
                        elevation: 2.0,
                        title: Text("Do you want to delete group?",style: TextStyle(color: Colors.lightBlue[900])),
                        actions: <Widget>[
                          MaterialButton(
                            onPressed: (){
                              DeleteGroup();
                              //Navigator.pop(context);
                            },
                            child: Text("Yes",style: TextStyle(color: Colors.lightBlue[900])),
                          ),
                          MaterialButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text("No",style: TextStyle(color: Colors.lightBlue[900])),
                          ),
                        ],
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SwitchItems extends StatefulWidget {
  Device d1,d2;
  SwitchItems(this.d1,this.d2);


  @override
  _SwitchItemsState createState() => _SwitchItemsState(d1,d2);
}

class _SwitchItemsState extends State<SwitchItems> {
  Device d1,d2;
  bool _value1=false;
  bool _value2=false;

  _SwitchItemsState(this.d1,this.d2);


  Future<bool>turnOffswitch(Device d) async{
    dynamic response = http.get('http://13.229.231.75:5000/TurnSwitchoff?DeviceName='+d.deviceName);
    return false;
  }


  Future<bool>incSwitch(Device d) async{
    dynamic response = http.get('http://13.229.231.75:5000/IncSwitch?DeviceName='+d.deviceName);
    return true;
  }

  Future<bool>DeleteSwitch(Device d) async{
    dynamic response = await http.get('http://13.229.231.75:5000/DeleteSwitch?DeviceName='+d.deviceName);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                height:60,
                width:10,
              ),
            ),
            Expanded(
              flex: 45,
              child:  InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration:BoxDecoration(
                    color: Colors.blueGrey[700],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  height: 60,
                  width:  90,
                  child: SwitchListTile(
                      value: _value1,
                      title: Text(d1.deviceName,style: TextStyle(color: Colors.white,fontSize: 12.0)),
                      inactiveThumbColor: Colors.yellow,
                      activeColor: Colors.yellow,
                      onChanged: (bool value){
                        setState(() {
                          _value1 = value;
                          print(_value1);
                          turnOffswitch(d1);
                          if(_value1 == true){
                            incSwitch(d1);

                          }

                        });

                      }),
                ),
                onLongPress: (){
                  showDialog(context:context, builder: (context){
                    return AlertDialog(
                      elevation: 2.0,
                      title: Text("Do you want to delete switch?",style: TextStyle(color: Colors.lightBlue[900])),
                      actions: <Widget>[
                        MaterialButton(
                          onPressed: (){
                            DeleteSwitch(d1);
                            //Navigator.pop(context);
                          },
                          child: Text("Yes",style: TextStyle(color: Colors.lightBlue[900])),
                        ),
                        MaterialButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("No",style: TextStyle(color: Colors.lightBlue[900])),
                        ),
                      ],
                    );
                  });
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height:60,
                width:6,
              ),
            ),
            Expanded(
              flex: 45,
              child:  InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  decoration:BoxDecoration(
                    color: Colors.blueGrey[700],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  height: 60,
                  width:  90,
                  child: SwitchListTile(
                      value: _value2,
                      title: Text(d2.deviceName,style: TextStyle(color: Colors.white,fontSize: 12.0)),
                      inactiveThumbColor: Colors.yellow,
                      activeColor: Colors.yellow,
                      onChanged: (bool value){
                        setState(() {
                          print(_value2);
                          turnOffswitch(d2);
                          _value2 = value;
                          if(_value2 == true){
                            incSwitch(d2);
                          }
                        });

                      }),
                ),
                onLongPress: (){
                  showDialog(context:context, builder: (context){
                    return AlertDialog(
                      elevation: 2.0,
                      title: Text("Do you want to delete switch?",style: TextStyle(color: Colors.lightBlue[900])),
                      actions: <Widget>[
                        MaterialButton(
                          onPressed: (){
                            DeleteSwitch(d2);
                            //Navigator.pop(context);
                          },
                          child: Text("Yes",style: TextStyle(color: Colors.lightBlue[900])),
                        ),
                        MaterialButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("No",style: TextStyle(color: Colors.lightBlue[900])),
                        ),
                      ],
                    );
                  });
                },
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height:60,
                width:10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}