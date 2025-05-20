import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/model/management.dart';
import 'package:kicksy/model/request.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart' as http;

class HqRequestList extends StatefulWidget {
  const HqRequestList({super.key});

  @override
  State<HqRequestList> createState() => _HqRequestListState();
}

class _HqRequestListState extends State<HqRequestList> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  late List<String> store;
  late String selectedStore;
  late String storeName;
  late int storeCode;
  late String modelName;
  late int modelSize;
  List requsetList = [];
  String wheres = ' ';

  var value = Get.arguments[0] ?? "__";
  @override
  void initState() {
    super.initState();
    store = [
      '지점',
      '강남지점',
      '강동지점',
      '강북지점',
      '강서지점',
      '관악지점',
      '광진지점',
      '지점로지점',
      '금천지점',
      '노원지점',
      '도봉지점',
      '동대문지점',
      '동작지점',
      '마포지점',
      '서대문지점',
      '서초지점',
      '성동지점',
      '성북지점',
      '송파지점',
      '양천지점',
      '영등포지점',
      '용산지점',
      '은평지점',
      '종로지점',
      '중지점',
      '중랑지점',
    ];
    selectedStore = '지점';
    storeName = ' ';
    storeCode = 0;
    modelName = ' ';
    modelSize = 0;
    getRequest(wheres);
  }

  getRequest(String where) async {
    var responseOdy = await http.get(
      Uri.parse('http://127.0.0.1:8000/request/view/${where}'),
    );
    requsetList.clear();
    requsetList.addAll(
      json.decode(utf8.decode(responseOdy.bodyBytes))['results'],
    );
    setState(() {});
  }

  getStoreName(int storeCode) {
    switch (storeCode) {
      case (1):
        storeName = '강남지점';
        break;
      case (2):
        storeName = '강동지점';
        break;
      case (3):
        storeName = '강북지점';
        break;
      case (4):
        storeName = '강서지점';
        break;
      case (5):
        storeName = '관악지점';
        break;
      case (6):
        storeName = '광진지점';
        break;
      case (7):
        storeName = '지점로지점';
        break;
      case (8):
        storeName = '금천지점';
        break;
      case (9):
        storeName = '노원지점';
        break;
      case (10):
        storeName = '도봉지점';
        break;
      case (11):
        storeName = '동대문지점';
        break;
      case (12):
        storeName = '동작지점';
        break;
      case (13):
        storeName = '마포지점';
        break;
      case (14):
        storeName = '서대문지점';
        break;
      case (15):
        storeName = '서초지점';
        break;
      case (16):
        storeName = '성동지점';
        break;
      case (17):
        storeName = '성북지점';
        break;
      case (18):
        storeName = '송파지점';
        break;
      case (19):
        storeName = '양천지점';
        break;
      case (20):
        storeName = '영등포지점';
        break;
      case (21):
        storeName = '용산지점';
        break;
      case (22):
        storeName = '은평지점';
        break;
      case (23):
        storeName = '종로지점';
        break;
      case (24):
        storeName = '중지점';
        break;
      case (25):
        storeName = '중랑지점';
        break;
    }
    return storeName;
  }

  getStoreCode(String selectedStore) {
    switch (selectedStore) {
      case ('강남지점'):
        storeCode = 1;
        break;
      case ('강동지점'):
        storeCode = 2;
        break;
      case ('강북지점'):
        storeCode = 3;
        break;
      case ('강서지점'):
        storeCode = 4;
        break;
      case ('관악지점'):
        storeCode = 5;
        break;
      case ('광진지점'):
        storeCode = 6;
        break;
      case ('지점로지점'):
        storeCode = 7;
        break;
      case ('금천지점'):
        storeCode = 8;
        break;
      case ('노원지점'):
        storeCode = 9;
      case ('도봉지점'):
        storeCode = 10;
        break;
      case ('동대문지점'):
        storeCode = 11;
        break;
      case ('동작지점'):
        storeCode = 12;
        break;
      case ('마포지점'):
        storeCode = 13;
        break;
      case ('서대문지점'):
        storeCode = 14;
        break;
      case ('서초지점'):
        storeCode = 15;
        break;
      case ('성동지점'):
        storeCode = 16;
        break;
      case ('성북지점'):
        storeCode = 17;
        break;
      case ('송파지점'):
        storeCode = 18;
        break;
      case ('양천지점'):
        storeCode = 19;
        break;
      case ('영등포지점'):
        storeCode = 20;
        break;
      case ('용산지점'):
        storeCode = 21;
        break;
      case ('은평지점'):
        storeCode = 22;
        break;
      case ('종로지점'):
        storeCode = 23;
        break;
      case ('중지점'):
        storeCode = 24;
        break;
      case ('중랑지점'):
        storeCode = 25;
        break;
      case ('지점'):
        storeCode = 0;
        break;
    }
    return storeCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: Center(
        child: Column(
          children: [
            DropdownButton(
              value: selectedStore,
              items:
                  store.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? value) {
                selectedStore = value!;
                if (selectedStore == "지점") {
                  wheres = ' ';
                } else {
                  getStoreCode(selectedStore);
                  wheres = 'and store_str_code = $storeCode';
                }
                getRequest(wheres);
                setState(() {});
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: requsetList!.length,
                itemBuilder: (context, index) {
                  // getModelName(snapshot.data![index].productCode);
                  // getProductSize(snapshot.data![index].productCode);
                  int thisStoreCode = requsetList![index]['store_str_code'];
                  String thisStoreName = getStoreName(thisStoreCode);

                  return Column(
                    children: [
                      Text(thisStoreName),
                      SizedBox(
                        height: 100,
                        width: 300,
                        child: Card(
                          child: Column(
                            children: [
                              Text("모델 명 : ${requsetList[index]['name']}"),
                              Text(
                                "고객 ID : ${requsetList[index]['user_email']}",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "사이즈 : ${requsetList[index]['size'].toString()}",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      "갯수 : ${requsetList[index]['req_count'].toString()}",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      requsetList[index]['req_type'] == 0
                          ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  // updateRtypeRejuct(snapshot.data![index].num!);
                                  // var manageInsert = Management(
                                  //   employeeCode: value,
                                  //   productCode:
                                  //       snapshot.data![index].productCode,
                                  //   storeCode: storeCode,
                                  //   type: -1,
                                  //   date: DateTime.now().toString(),
                                  //   count: snapshot.data![index].count,
                                  // );

                                  // await databaseHandler.insertManagement(
                                  //   manageInsert,
                                  // );

                                  await updateType(
                                    -1,
                                    requsetList[index]['req_num'],
                                  );
                                  getRequest(wheres);
                                },
                                child: Text('미승인'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  // updateRtype(snapshot.data![index].num!);
                                  // var manageInsert = Management(
                                  //   employeeCode: value,
                                  //   productCode:
                                  //       snapshot.data![index].productCode,
                                  //   storeCode: storeCode,
                                  //   type: 1,
                                  //   date: DateTime.now().toString(),
                                  //   count: snapshot.data![index].count,
                                  // );

                                  // await databaseHandler.insertManagement(
                                  //   manageInsert,
                                  // );
                                  await updateType(
                                    1,
                                    requsetList[index]['req_num'],
                                  );
                                  getRequest(wheres);
                                },
                                child: Text('승인'),
                              ),
                            ],
                          )
                          : requsetList[index]['req_type'] == 1
                          ? Text('승인')
                          : Text('거부'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // getModelName(int productCode) async {
  //   final productList = await databaseHandler.getProductName(productCode);
  //   if (productList.isNotEmpty) {
  //     modelName = productList[0].name;
  //     setState(() {});
  //   }
  //   return modelName;
  // }

  // getProductSize(int productCode) async {
  //   final productList = await databaseHandler.getProductSize(productCode);
  //   if (productList.isNotEmpty) {
  //     modelSize = productList[0].size;
  //     setState(() {});
  //   }
  //   return modelName;
  // }

  updateType(int types, int num) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('http://127.0.0.1:8000/request/update'),
    );
    request.fields['req_type'] = types.toString();
    request.fields['reason'] = types == 1 ? " " : "재고 부족";
    request.fields['req_num'] = num.toString();
    var res = await request.send();
  }

  // updateRtype(int iNum) async {
  //   int result = 0;

  //   var rTypeUpdate = Request(
  //     num: iNum,
  //     userId: '',
  //     productCode: 0,
  //     storeCode: storeCode,
  //     type: 1,
  //     date: '',
  //     count: 0,
  //   );
  //   result = await databaseHandler.updateRequest(rTypeUpdate);
  // }

  // updateRtypeRejuct(int iNum) async {
  //   int result = 0;

  //   var rTypeUpdate = Request(
  //     num: iNum,
  //     userId: '',
  //     productCode: 0,
  //     storeCode: storeCode,
  //     type: -1,
  //     date: '',
  //     count: 0,
  //   );
  //   result = await databaseHandler.updateRequest(rTypeUpdate);
  // }
}
