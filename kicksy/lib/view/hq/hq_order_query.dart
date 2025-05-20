import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart' as http;

class HqOrderQuery extends StatefulWidget {
  const HqOrderQuery({super.key});

  @override
  State<HqOrderQuery> createState() => _HqOrderQueryState();
}

class _HqOrderQueryState extends State<HqOrderQuery> {
  
  List documentList = [];
  List orderyingList = [];
  // DatabaseHandler handler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    getJSONDataOdy(); 
    getJSONDateEmp();
  }

  getJSONDateEmp() async {
    var responseOdy = await http.get(
      Uri.parse('http://127.0.0.1:8000/document'),
    );
    documentList.clear();
    documentList.addAll(
      json.decode(utf8.decode(responseOdy.bodyBytes))['results'],
    );
    setState(() {});
    print(documentList);
  }


  getJSONDataOdy() async {
    var responseOdy = await http.get(
      Uri.parse('http://127.0.0.1:8000/orderying'),
    );
    orderyingList.clear();
    orderyingList.addAll(
      json.decode(utf8.decode(responseOdy.bodyBytes))['results'],
    );
    setState(() {});
    print(orderyingList);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      documentList.isEmpty && orderyingList.isEmpty
      ? Center(child: CircularProgressIndicator())
      : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            Row(
              children: [
                Text('발주 번호'),
                Text('기안자'), 
                Text('날짜'), 
                Text('결재 상태'),
              ],
            ), 
            Expanded(
              child: ListView.builder(
                itemCount: orderyingList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('${orderyingList[index]['ody_num']}'),
                        Text('${documentList[index]['proposer']}'),
                        Text('${orderyingList[index]['ody_date']}'),
                        Text('${orderyingList[index]['ody_type']}'),
                      ],
                    ),
                  );
                },
                ),
            )
        ],
      ),
    );
  }
}
