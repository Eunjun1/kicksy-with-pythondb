import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/model/document.dart';
import 'package:kicksy/model/orderying.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart' as http;

class HqInsertOrderDocument extends StatefulWidget {
  const HqInsertOrderDocument({super.key});

  @override
  State<HqInsertOrderDocument> createState() => _HqInsertOrderDocumentState();
}

class _HqInsertOrderDocumentState extends State<HqInsertOrderDocument> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  TextEditingController numCT = TextEditingController();
  TextEditingController propserCT = TextEditingController();
  TextEditingController titleCT = TextEditingController();
  TextEditingController contentCT = TextEditingController();
  TextEditingController dateCT = TextEditingController();
  TextEditingController odyNumCT = TextEditingController();
  TextEditingController employeeCodeCT = TextEditingController();
  TextEditingController productCodeCT = TextEditingController();
  TextEditingController documentCodeCT = TextEditingController();
  TextEditingController odyTypeCT = TextEditingController();
  TextEditingController odyDateCT = TextEditingController();
  TextEditingController odyCountCT = TextEditingController();
  TextEditingController rejectReasonCT = TextEditingController();
  late List docNum;
  late List modCode;
  var value = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();
    docNum = [];
    modCode = [];
    getMaxData();
  }

  getMaxData() async {
    var responseDoc = await http.get(
      Uri.parse('http://127.0.0.1:8000/document/doc_code'),
    );
    docNum.clear();
    docNum.addAll(json.decode(utf8.decode(responseDoc.bodyBytes))['results']);
    setState(() {});
    print(docNum);
    print(value);
    print(docNum[0]['maxcode']);
  }

  changeNameForCode() async {
    var responseDoc = await http.get(
      Uri.parse('http://127.0.0.1:8000/model/namecode=${productCodeCT.text}'),
    );
    modCode.clear();
    modCode.addAll(json.decode(utf8.decode(responseDoc.bodyBytes))['results']);
    setState(() {});
    print(modCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          '발주결재',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1, color: Colors.black),
              ),
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 300,
              // color:Color(0xFFffffff),
              child: SizedBox(
                width: 250,
                child: Column(
                  // Text('기안자 :     ',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //기안자
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: propserCT,
                          decoration: InputDecoration(labelText: '기안자'),
                        ),
                      ),
                    ),
                    //제목
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: titleCT,
                          decoration: InputDecoration(labelText: '제목'),
                        ),
                      ),
                    ),
                    //내용
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: contentCT,
                          decoration: InputDecoration(labelText: '내용'),
                        ),
                      ),
                    ),
                    //직원코드
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: employeeCodeCT,
                          decoration: InputDecoration(labelText: '직원 코드'),
                        ),
                      ),
                    ),

                    //제품번호
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: productCodeCT,
                          decoration: InputDecoration(labelText: '제품 이름'),
                        ),
                      ),
                    ),
                    //오더타입

                    //구매 수량
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: odyCountCT,
                          decoration: InputDecoration(labelText: '발주 수량'),
                        ),
                      ),
                    ),
                    //거절이유
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: SizedBox(
                        width: 300,
                        child: TextField(
                          controller: rejectReasonCT,
                          decoration: InputDecoration(labelText: '거절 이유'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                onPressed: () {
                  var value = Get.arguments[0];
                  setState(() {
                    insertDocument();
                    insertOrderying();
                    setState(() {});
                    Get.back();
                  });
                  print(value);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFBF1F),
                  minimumSize: Size(350, 40),
                ),
                child: Text(
                  '입력',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  insertDocument() async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('http://127.0.0.1:8000/document/insert'),
    );
    request.fields['proposer'] = propserCT.text;
    request.fields['title'] = titleCT.text;
    request.fields['contents'] = contentCT.text;
    request.fields['date'] = DateTime.now().toString();
    var res = await request.send();
    if (res.statusCode == 200) {
      Get.snackbar('완', '완');
    } else {
      Get.snackbar('X', 'X');
    }
    setState(() {});
  }

  insertOrderying() async {
    await changeNameForCode();
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('http://127.0.0.1:8000/orderying/insert'),
    );
    request.fields['emp_code'] = value[0];
    request.fields['doc_code'] = docNum[0]['maxcode'].toString();
    request.fields['prod_code'] = modCode[0]['mod_code'].toString();
    request.fields['ody_type'] = 1.toString();
    request.fields['ody_date'] = DateTime.now().toString();
    request.fields['ody_count'] = odyCountCT.text;
    request.fields['reject_reason'] = rejectReasonCT.text;
    var res = await request.send();
    if (res.statusCode == 200) {
      Get.snackbar('완', '완');
    } else {
      Get.snackbar('X', 'X');
    }
    setState(() {});
  }
}
