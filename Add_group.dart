import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intellihome/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Add_group extends StatefulWidget {
  @override
  _Add_groupState createState() => _Add_groupState();
}

class _Add_groupState extends State<Add_group> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
            Navigator.pop(context);
          }),
          backgroundColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.yellow,opacity: 3.0,size: 5),
        ),
        body: GroupForm(),
      ),
    );
  }
}

class GroupForm extends StatefulWidget {
  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  TextEditingController NameController;
  List selectedswitches;
  final _FormKey = GlobalKey<FormState>();

  Future<bool> AddGroup(String groupname, List selectedswitches) async {
    int count = selectedswitches.length;
    print(groupname);
    print(selectedswitches);
    if(count == 2){
    dynamic response = await http.get('http://13.229.231.75:5000/AddGroup?GroupName='+groupname+'&Device1='+selectedswitches[0].toString()+'&Device2='+selectedswitches[1].toString());
    print(response);
    return true;
    }
    else if(count ==3){
      dynamic response = await http.get('http://13.229.231.75:5000/AddGroup?GroupName='+groupname+'&Device1='+selectedswitches[0].toString()+'&Device2='+selectedswitches[1].toString()+'&Device3='+selectedswitches[2].toString());
      return true;
    }
    else{
      dynamic response = await http.get('http://13.229.231.75:5000/AddGroup?GroupName='+groupname+'&Device1='+selectedswitches[0].toString()+'&Device2='+selectedswitches[1].toString()+'&Device3='+selectedswitches[2].toString()+'&Device4='+selectedswitches[3].toString());
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NameController = TextEditingController() ;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _FormKey,
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: Container(
                height: 100,
                width: 300,
                child: Text("ADD GROUP",style: TextStyle(fontSize: 40.0,fontStyle: FontStyle.normal),textAlign: TextAlign.center,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: 60,
                width: 300,
                decoration:BoxDecoration(
                  color: Colors.blueGrey[700],
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: NameController,
                    decoration: InputDecoration(
                      focusColor: Colors.white,
                      enabled: true,
                      hintStyle: TextStyle(color: Colors.black),
                      hintText: "Group name",
                    ),
                    textAlign: TextAlign.center,
                    validator: (value){
                      if(value.isEmpty){
                        return "Enter group name";
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
            InkWell(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Container(
                  height: 60,
                  width: 300,
                  decoration:BoxDecoration(
                    color: Colors.blueGrey[700],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: ListTile(
                    title: Text("Add switch",textAlign: TextAlign.center),
                    trailing: Icon(Icons.add_circle_outline,size: 20.0),
                  ),
                ),
              ),
              onTap: () async {
                selectedswitches = await _showMultiSelect(context);

              }
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              color: Colors.black12,
              onPressed: (){
                if(NameController != null && selectedswitches !=null && _FormKey.currentState.validate()) {
                  AddGroup(NameController.text,selectedswitches);
                  NameController.clear();
                }
              },
              child: Text("Add Group",style: TextStyle(color: Colors.white70)),
              padding: EdgeInsets.symmetric(horizontal: 1.0),
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectDialogItem {
  const MultiSelectDialogItem( this.label);

  final String label;
}

class MultiSelectDialog extends StatefulWidget {
  MultiSelectDialog({Key key, this.items, }) : super(key: key);
  final List<MultiSelectDialogItem> items;
  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  final _selectedValues = new List();

  void _onItemCheckedChange(String itemLabel, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemLabel);
      } else {
        _selectedValues.remove(itemLabel);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Switches'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem item) {
    final checked = _selectedValues.contains(item.label);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.label, checked),
    );
  }
}

 _showMultiSelect(BuildContext context) async {
  final List<MultiSelectDialogItem> items = await FindSwitches();

  final selectedValues = await showDialog<List>(
    context: context,
    builder: (BuildContext context) {
      return MultiSelectDialog(
        items: items,
      );
    },
  );

  //print(selectedValues);
  return selectedValues;
}

Future<List<MultiSelectDialogItem>>FindSwitches() async{
  List<String> Switches = [];
  final List<MultiSelectDialogItem> items = [];
  var response = await http.get('http://13.229.231.75:5000/FindSwitches');
  var switches = json.decode(response.body);

  for (var x in switches){
    String Switch = x['DeviceName'];
    Switches.add(Switch);

  }
  print(Switches);
  for (var a in Switches){
    MultiSelectDialogItem item = MultiSelectDialogItem(a);
    items.add(item);
  }
  return items;
}