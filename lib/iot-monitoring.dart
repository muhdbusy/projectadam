import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Iotmon extends StatefulWidget {
  const Iotmon({super.key});

  @override
  State<Iotmon> createState() => _IotmonitoringState();
}
class _IotmonitoringState extends State<Iotmon> {

  //final DatabaseReference myRTDB = FirebaseDatabase.instance.ref();
  final DatabaseReference myRTDB = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://fir-auth-93288-default-rtdb.asia-southeast1.firebasedatabase.app",).ref();
  String rssiValue = '0';



  void readSensorValue(){
    //
    myRTDB.child('Sensor/rssi').onValue.listen(
            (event){
          final Object? rssiData = event.snapshot.value;
          setState(() {
            rssiValue = rssiData.toString();
          });
        }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readSensorValue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Sensor'),
          centerTitle: true,
          backgroundColor: Color(0xFEE16666)
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Card(
              child: ListTile(
                  title: Text('WiFi RSSI',style: TextStyle(fontSize: 30),),
                  subtitle: Text('$rssiValue dBm',style: TextStyle(fontSize: 30),
                  )
                //Column(
                //children: [
                //Text('RSSI Value',style: TextStyle(fontSize: 35),),
                //Text('$rssiValue dBm',style: TextStyle(fontSize: 35),)
                //],
              ),
            )
          ],
        ),
      ),
    );
  }
}