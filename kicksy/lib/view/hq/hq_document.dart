import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/model/orderying.dart';
import 'package:kicksy/vm/database_handler.dart';

class HqDocument extends StatefulWidget {
  const HqDocument({super.key});

  @override
  State<HqDocument> createState() => _HqDocumentState();
}

class _HqDocumentState extends State<HqDocument> {
  DatabaseHandler databaseHandler = DatabaseHandler();

  DatabaseHandler handler = DatabaseHandler();

  var value = Get.arguments ?? "__";
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
        child: FutureBuilder(
          future: handler.queryOrderyingWithDocumentWithEmployee(value[0]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int type = snapshot.data![0].orderying.type;
              int num = snapshot.data![0].orderying.num!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    color: Color(0xFFD9D9D9),
                    width: 350,
                    height: 600,
                    child: Column(
                      children: [
                        Text(
                          '발주 번호 : ${snapshot.data![0].orderying.num.toString()}',
                        ),
                        Text('문서 제목 : ${snapshot.data![0].document.title}'),
                        Text('기안자 : ${snapshot.data![0].document.propser}'),
                        Text('기안 날짜 : ${snapshot.data![0].document.date}'),
                        Text(
                          '문서 내용 : 제품 코드 ${snapshot.data![0].orderying.productCode} | ${snapshot.data![0].orderying.count}개 주문',
                        ),
                        Text(
                          snapshot.data![0].orderying.type == 0
                              ? '팀장 결재중'
                              : snapshot.data![0].orderying.type == 1
                              ? '이사 결재중'
                              : snapshot.data![0].orderying.type == 2
                              ? '결제 완료'
                              : '반려',
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder(
                    future: handler.queryEmployee(value[1]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return type == 0 && snapshot.data![0].grade == '팀장'
                            ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    updateOrderType(num, type);
                                    Get.back();
                                  },
                                  child: Container(
                                    width: 350,
                                    color: Color(0xFFFFBF1F),
                                    child: Text(
                                      '승인',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    updateOrderTypeNo(num, type);
                                    Get.back();
                                  },
                                  child: Container(
                                    color: Color(0xFFD9D9D9),
                                    width: 350,
                                    child: Text(
                                      '부결',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : type == 1 && snapshot.data![0].grade == '이사'
                            ? Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    updateOrderType(num, type);
                                    Get.back();
                                  },
                                  child: Container(
                                    width: 350,
                                    color: Color(0xFFFFBF1F),
                                    child: Text(
                                      '승인',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    updateOrderTypeNo(num, type);
                                    Get.back();
                                  },
                                  child: Container(
                                    color: Color(0xFFD9D9D9),
                                    width: 350,
                                    child: Text(
                                      '부결',
                                      textAlign: TextAlign.center,
                                    ),
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
                                      child: Text(
                                        '확인',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      // Center(
      //   child: FutureBuilder(
      //     future: handler.queryOrderyingWithDocumentWithEmployee(),
      //     builder: (context, snapshot) {
      //       return Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       children: [
      //         Container(
      //           color: Color(0xFFD9D9D9),
      //           width: 350,
      //           height: 600,
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: [
      //               Text('기안자 : ${documentList[0].propser}'),
      //               Text('문서 제목 : ${documentList[0].title}'),
      //               Text('문서 내용 : ${documentList[0].contents}'),
      //               Text('기안 날짜 : ${documentList[0].date.toString().substring(0, 10)}'),
      //               Text(
      //                 documentList[0].type == 0
      //                 ? '팀장 결재중'
      //                 : documentList[0].type == 1
      //                 ? '이사 결재중'
      //                 : documentList[0].type == -1
      //                 ? '반려'
      //                 : '결제 완료'
      //               ),
      //             ],
      //           ),
      //         ),
      //         documentList[0].type == 0 && documentList[0].grade == '팀장'
      //             ? Column(
      //               children: [
      //                 GestureDetector(
      //                   onTap: () {
      //                     // 업데이트 (type를 +1함)
      //                     Get.back();
      //                   },
      //                   child: Container(
      //                     width: 350,
      //                     color: Color(0xFFFFBF1F),
      //                     child: Text('승인', textAlign: TextAlign.center),
      //                   ),
      //                 ),
      //                 GestureDetector(
      //                   onTap: () {
      //                     //업데이트
      //                     Get.back();
      //                   },
      //                   child: Container(
      //                     color: Color(0xFFD9D9D9),
      //                     width: 350,
      //                     child: Text('부결', textAlign: TextAlign.center),
      //                   ),
      //                 ),
      //               ],
      //             )
      //             : documentList[0].type == 1 && documentList[0].grade == '이사'
      //             ? Column(
      //               children: [
      //                 GestureDetector(
      //                   onTap: () {
      //                     // 업데이트 (type를 +1함)
      //                     Get.back();
      //                   },
      //                   child: Container(
      //                     width: 350,
      //                     color: Color(0xFFFFBF1F),
      //                     child: Text('승인', textAlign: TextAlign.center),
      //                   ),
      //                 ),
      //                 GestureDetector(
      //                   onTap: () {
      //                     //업데이트
      //                     Get.back();
      //                   },
      //                   child: Container(
      //                     color: Color(0xFFD9D9D9),
      //                     width: 350,
      //                     child: Text('부결', textAlign: TextAlign.center),
      //                   ),
      //                 ),
      //               ],
      //             )
      //             : Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 GestureDetector(
      //                   onTap: () => Get.back(),
      //                   child: SizedBox(
      //                     width: 350,
      //                     child: ColoredBox(
      //                       color: Color(0xFFD9D9D9),
      //                       child: Text('확인', textAlign: TextAlign.center),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //       ],
      //     );
      //     },
      //   ),
      // ),
    );
  }

  updateOrderType(int numO, int oType) async {
    int result = 0;

    var typeUpdate = Orderying(
      num: numO,
      employeeCode: 0,
      productCode: 0,
      documentCode: 0,
      type: oType + 1,
      date: DateTime.now().toString(),
      count: 0,
    );

    result = await handler.updateOrdertype(typeUpdate);
  }

  updateOrderTypeNo(int numO, int oType) async {
    int result = 0;

    var typeUpdate = Orderying(
      num: numO,
      employeeCode: 0,
      productCode: 0,
      documentCode: 0,
      type: 3,
      date: DateTime.now().toString(),
      count: 0,
    );

    result = await handler.updateOrdertype(typeUpdate);
  }
}
