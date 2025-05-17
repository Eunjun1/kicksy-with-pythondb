
import 'package:flutter/material.dart';
import 'package:kicksy/vm/database_handler.dart';

class HqCustomerOrder extends StatefulWidget {
  const HqCustomerOrder({super.key});

  @override
  State<HqCustomerOrder> createState() => _HqCustomerOrderState();
}

class _HqCustomerOrderState extends State<HqCustomerOrder> {
  DatabaseHandler handler = DatabaseHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: handler.queryModelwithImage(''),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      Image.memory(snapshot.data![index].images.image),
                      Column(
                        children: [
                          Text('모델명 : ${snapshot.data![index].model.code}'),
                          Text('모델명 : ${snapshot.data![index].model.name}'),
                          Text(
                            '모델명 : ${snapshot.data![index].model.saleprice}',
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
