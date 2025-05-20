import 'package:flutter/material.dart';
import 'package:kicksy/vm/database_handler.dart';

class HqRequestManagement extends StatefulWidget {
  const HqRequestManagement({super.key});

  @override
  State<HqRequestManagement> createState() => _HqRequestManagementState();
}

class _HqRequestManagementState extends State<HqRequestManagement> {
  List data = [];
  DatabaseHandler handler = DatabaseHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      
      body: Center(
        child: FutureBuilder(
          future: handler.queryManagement(), 
          builder: (context, snapshot) {
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(children: [Text('data')],),
                  );
                },);
            } else {
              return CircularProgressIndicator();
            }
          },),
      ),
    );
  }
}