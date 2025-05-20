import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kicksy/model/model.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart' as http;

class HqCustomerOrder extends StatefulWidget {
  const HqCustomerOrder({super.key});

  @override
  State<HqCustomerOrder> createState() => _HqCustomerOrderState();
}

class _HqCustomerOrderState extends State<HqCustomerOrder> {
  List imageList = [];
  List modelList = [];
  // DatabaseHandler handler = DatabaseHandler();

  @override
  void initState() {
    super.initState();
    getJSONDataImg();
    getJSONDataModel();
  }

  getJSONDataImg() async {
    var responseImage = await http.get(
      Uri.parse('http://127.0.0.1:8000/image/select'),
    );
    imageList.clear();
    imageList.addAll(
      json.decode(utf8.decode(responseImage.bodyBytes))['results'],
    );
    print(imageList);
    setState(() {});
  }

  getJSONDataModel() async {
    var responseModel = await http.get(
      Uri.parse('http://127.0.0.1:8000/model/selectAll'),
    );
    modelList.clear();
    modelList.addAll(
      json.decode(utf8.decode(responseModel.bodyBytes))['results'],
    );

    setState(() {});
    print(modelList);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imageList.isEmpty && modelList.isEmpty 
      ? Center(
        child: CircularProgressIndicator(),
      )
      :
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: modelList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Row(
                    children: [
                      // Image.network(
                      //   '${imageList[index]["image"]}',
                      //   width: 30,
                      // ),
                      Column(
                        children: [
                          Text('모델명: ${modelList[index]['mod_code']}'),
                          Text('모델명: ${modelList[index]['name']}'),
                          Text('모델명: ${modelList[index]['saleprice']}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  
  }
}
