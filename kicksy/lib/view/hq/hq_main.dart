import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:kicksy/view/hq/hq_document.dart';
import 'package:kicksy/view/hq/hq_insert.dart';
import 'package:kicksy/view/hq/hq_insert_order_document.dart';
import 'package:kicksy/view/hq/hq_model_detail.dart';
import 'package:kicksy/view/hq/hq_request_list.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart' as http;

class HqMain extends StatefulWidget {
  const HqMain({super.key});

  @override
  State<HqMain> createState() => _HqMainState();
}

class _HqMainState extends State<HqMain> {
  //property
  DatabaseHandler handler = DatabaseHandler();
  late List<String> productList;
  List modelList = [];
  List employeeList = [];
  List documentList = [];
  List orderyingList = [];
  bool view = false;
  var value = Get.arguments[0] ?? "__";
  late String dropDownValue;

  @override
  void initState() {
    super.initState();
    productList = ['제품 목록', '발주 목록'];
    dropDownValue = productList[0];
    getJSONDateEmp();
    getJSONDataModel();
    getJSONDataOdy();
    print(value);
  }

  getJSONDataModel() async {
    var responseModel = await http.get(
      Uri.parse('http://127.0.0.1:8000/model'),
    );
    modelList.clear();
    modelList.addAll(
      json.decode(utf8.decode(responseModel.bodyBytes))['results'],
    );

    setState(() {});
  }

  getJSONDateEmp() async {
    var responseEmp = await http.get(
      Uri.parse('http://127.0.0.1:8000/employee/${int.parse(value)}'),
    );
    employeeList.clear();
    employeeList.addAll(
      json.decode(utf8.decode(responseEmp.bodyBytes))['results'],
    );
    setState(() {});
    print(employeeList);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:
          modelList.isEmpty && orderyingList.isEmpty && employeeList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              employeeList[0]['division'],
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            employeeList[0]['grade'],
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(children: [
                                
                              ],
                            ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 230,
                            child: DropdownButton(
                              value: dropDownValue,
                              items:
                                  productList.map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              130,
                                              0,
                                            ),
                                            child: Text(value),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (String? value) {
                                dropDownValue = value!;
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              child: ElevatedButton(
                                onPressed: () {
                                  Get.to(HqRequestList(), arguments: [value]);
                                },
                                child: Text('주문내역'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child:
                            dropDownValue == '제품 목록'
                                ? ListView.builder(
                                  itemCount: modelList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          HqModelDetail(),
                                          arguments: [
                                            modelList[index]["name"],
                                            modelList[index]['mod_code'],
                                            modelList[0]['image_num'],
                                          ],
                                        );
                                      },
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Image.network(
                                              "http://127.0.0.1:8000/image/view/name=${modelList[index]['name']}&img_num=0?t=${DateTime.now().millisecondsSinceEpoch}",
                                              width: 100,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 20.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      '모델명 : ${modelList[index]['name']}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      '제조사 : ${modelList[index]['company']}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 200,
                                                    child: Text(
                                                      '가격 : ${modelList[index]['saleprice']}',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // FutureBuilder(
                                            //   future: handler.queryRequestWithProductWithModel(snapshot.data![index].model.code!),
                                            //   builder: (context, snapshot) {
                                            //     if (snapshot.hasData){
                                            //     return SizedBox(
                                            //       width: 30,
                                            //       height: 30,
                                            //       child: Row(
                                            //         children: [
                                            //           Text(snapshot.data![0].request.count.toString()),
                                            //           Text('/'),
                                            //           Text(snapshot.data![0].product.maxstock.toString())
                                            //         ],
                                            //       ),
                                            //     );
                                            //   } else {
                                            //     return CircularProgressIndicator();
                                            //   }
                                            // })
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                                : Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 400,
                                      color: Colors.yellow,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('발주 번호'),
                                          Text('제목'),
                                          Text('기안자'),
                                          Text('날짜'),
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: T,
                                      itemCount: orderyingList.length,
                                      itemBuilder: (context, index) {
                                        if (view == false) {
                                          getJSONDataDoc(
                                            orderyingList[index]['doc_code'],
                                          );
                                        }
                                        return documentList.isEmpty
                                            ? Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                            : GestureDetector(
                                              onTap:
                                                  () => Get.to(
                                                    () => HqDocument(),
                                                    arguments: [
                                                      documentList[index]['doc_code'],
                                                      value,
                                                    ],
                                                  ),
                                              child: Card(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      orderyingList[index]['ody_num']
                                                          .toString(),
                                                    ),
                                                    Text(
                                                      documentList[0]['title'],
                                                    ),
                                                    Text(
                                                      documentList[0]['proposer'],
                                                    ),
                                                    Text(
                                                      documentList[0]['date']
                                                          .toString()
                                                          .substring(0, 10),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                      },
                                    ),
                                  ],
                                ),
                      ),
                    ],
                  ), // FutureBuilder
                ),
              ),

      floatingActionButton:
          dropDownValue == '제품 목록'
              ? IconButton(
                onPressed: () => Get.to(() => HqInsert()),
                icon: Icon(Icons.add),
              )
              : IconButton(
                onPressed:
                    () => Get.to(HqInsertOrderDocument(), arguments: [value]),
                icon: Icon(Icons.add),
              ),
    );
  }

  getJSONDataDoc(int code) async {
    var responseDoc = await http.get(
      Uri.parse('http://127.0.0.1:8000/document/$code'),
    );
    documentList.clear();
    documentList.addAll(
      json.decode(utf8.decode(responseDoc.bodyBytes))['results'],
    );
    view = true;
    setState(() {});
  }
}
