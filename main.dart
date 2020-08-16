import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:intellihome/Add_device.dart';
import 'package:intellihome/Add_group.dart';
import 'dart:convert';
import 'package:intellihome/ControlPanel.dart';


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor:  Colors.blueGrey,
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  TextEditingController SsidController, PasswordController;
  final _FormKey = GlobalKey<FormState>();
  final log = Logger();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SsidController = TextEditingController() ;
    PasswordController = TextEditingController() ;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _FormKey,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: 100,
              ),
            Flexible(
              flex: 1,
              fit:FlexFit.loose,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child:
                      RichText(text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Intelli',style: TextStyle(fontSize: 50.0,color: Colors.yellow[600],fontStyle: FontStyle.italic,fontFamily: 'Pacifico')),
                          TextSpan(text: ' Home',style: TextStyle(fontSize: 60.0,color:Colors.yellow,fontFamily: 'Yanone',fontWeight: FontWeight.bold)),
                        ],
                      )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 6,
              fit: FlexFit.loose,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blueGrey[700],
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),

                  height: 400,
                  width: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: SsidController,
                            decoration: InputDecoration(
                              focusColor: Colors.white,
                              enabled: true,
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white),
                              ),

                              hintText: "SSID",

                            ),
                            textAlign: TextAlign.center,
                            validator: (value){
                              if(value.isEmpty){
                                return "ENTER YOUR WIFI SSID";
                              }
                              return null;
                            },
                          ),
                        ),

                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0,vertical: 10.0),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            controller: PasswordController,
                            decoration: InputDecoration(

                              focusColor: Colors.white,
                              enabled: true,
                              hintStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintText: "PASSWORD",
                            ),
                            validator: (value){
                              if(value.isEmpty){
                                return "PASSWORD REQUIRED";
                              }
                              if(value.length <8){
                                return "8 CHARACTERS LONG CODEWORD";
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            obscureText: true,

                          ),
                        ),
                      ),
                      RaisedButton(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        color: Colors.black12,
                        onPressed: (){
                          log.d('bitch');
                          if(SsidController != null && PasswordController != null && _FormKey.currentState.validate()) {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> new ControlPanel()));
                          }
                        },
                        child: Text("login",style: TextStyle(color: Colors.white70)),
                        padding: EdgeInsets.symmetric(horizontal: 1.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
