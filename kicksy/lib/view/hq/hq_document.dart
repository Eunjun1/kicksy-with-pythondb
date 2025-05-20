import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/model/orderying.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart' as http;

class HqDocument extends StatefulWidget {
  const HqDocument({super.key});

  @override
  State<HqDocument> createState() => _HqDocumentState();
}

class _HqDocumentState extends State<HqDocument> {
  List docList = [];
  List empList = [];
  late int type;
  late int num;
  DatabaseHandler databaseHandler = DatabaseHandler();

  DatabaseHandler handler = DatabaseHandler();

var value = [1,1];
  // var value = Get.arguments ?? "__";

  @override
  void initState(){
    super.initState();
    getDocJSONData(value[0]);
    getEmpJSONData(3);
  }


  getDocJSONData(int docCode) async {
    var url = Uri.parse(
      'http://127.0.0.1:8000/document/select/Orderying_Document_Employee_Product/$docCode',
    );
    var response = await http.get(url);

    if (response.statusCode == 200) {
      docList.clear();
      docList.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
      type = docList[0]['ody_type'];
      num = docList[0]['ody_num'];
      setState(() {});
    }
  }

  getEmpJSONData(int empCode) async {
    var url = Uri.parse('http://127.0.0.1:8000/employee/$empCode');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      empList.clear();
      empList.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: (docList.isEmpty || empList.isEmpty)
      ? CircularProgressIndicator() // 로딩 중일 때
      : Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              color: Color(0xFFD9D9D9),
              width: 350,
              height: 600,
              child: Column(
                children: [
                  Text('발주 번호 : ${docList[0]['ody_num'].toString()}'),
                  Text('문서 제목 : ${docList[0]['title']}'),
                  Text('기안자 : ${docList[0]['proposer']}'),
                  Text('기안 날짜 : ${docList[0]['ody_date']}'),
                  Text(
                    '문서 내용 : 제품 코드 ${docList[0]['prod_code']} | ${docList[0]['ody_count']}개 주문',
                  ),
                  Text(
                    docList[0]['ody_type'] == 0
                        ? '팀장 결재중'
                        : docList[0]['ody_type'] == 1
                        ? '이사 결재중'
                        : docList[0]['ody_type'] == 2
                        ? '결제 완료'
                        : '반려',
                  ),
                ],
              ),
            ),
            type == 0 && empList[0]['grade'] == '팀장'
                ? Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        updateOdyType();
                        Get.back();
                      },
                      child: Container(
                        width: 350,
                        color: Color(0xFFFFBF1F),
                        child: Text('승인', textAlign: TextAlign.center),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        updateOdyTypeNo();
                        Get.back();
                      },
                      child: Container(
                        color: Color(0xFFD9D9D9),
                        width: 350,
                        child: Text('부결', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                )
                : type == 1 && empList[0]['grade'] == '이사'
                ? Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        updateOdyType();
                        Get.back();
                      },
                      child: Container(
                        width: 350,
                        color: Color(0xFFFFBF1F),
                        child: Text('승인', textAlign: TextAlign.center),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        updateOdyTypeNo();
                        Get.back();
                      },
                      child: Container(
                        color: Color(0xFFD9D9D9),
                        width: 350,
                        child: Text('부결', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: SizedBox(
                        width: 350,
                        child: ColoredBox(
                          color: Color(0xFFD9D9D9),
                          child: Text('확인', textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
  
  updateOdyType() async {
    final uri = Uri.parse('http://127.0.0.1:8000/orderying/update');
    var request = http.MultipartRequest('POST',uri);
      request.fields['ody_type'] = (docList[0]['ody_type'] + 1).toString();
      request.fields['ody_num'] = (docList[0]['ody_num']).toString();

      var res = await request.send();
      if (res.statusCode == 200){
        showDialog();
      } else{
        errorSnackBar();
      }
  }

  updateOdyTypeNo() async {
    final uri = Uri.parse('http://127.0.0.1:8000/orderying/update/');
    var request = http.MultipartRequest('POST',uri);
      request.fields['ody_type'] = 3.toString();
      request.fields['ody_num'] = (docList[0]['ody_num']).toString();
      
      var res = await request.send();
      if (res.statusCode == 200){
        showDialog();
      } else{
        errorSnackBar();
      }
  }
  
  showDialog() {
    Get.defaultDialog(
      title: '입력',
      middleText: '입력되었습니다..',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: Text('Ok'),
        ),
      ],
    );
  }

  errorSnackBar() {
    Get.snackbar(
      'Error',
      '입력시 문제가 발생했습니다',
      duration: Duration(seconds: 2),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }
}
