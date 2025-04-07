import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class IotControlling extends StatefulWidget {
  const IotControlling({super.key});

  @override
  State<IotControlling> createState() => _IotControllingState();
}

class _IotControllingState extends State<IotControlling> {

  final DatabaseReference myRTDB = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://monitor-fea10-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref();
  bool pumpSwitch = false;

  void readSwitchStatus(){
    myRTDB.child('Actuator/led').onValue.listen((event){
      setState(() {
        pumpSwitch = event.snapshot.value as bool? ?? false;
      });
    });
  }

  void updatePumpSwitch(bool value){
    myRTDB.child('Actuator/led').set(value);
    setState(() {
      pumpSwitch = value;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Actuator'),
        centerTitle: true,
        backgroundColor: Color(0xFF90FAB2),
      ),

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 15,),
              Text('Actuator Control'),
              Card(
                color: Color(0xFF90FAB2),
                child: ListTile(
                  title: Text('Pump'),
                  trailing: Switch(
                      value: pumpSwitch,
                      onChanged: (bool value){updatePumpSwitch(value);}
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}