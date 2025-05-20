import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/view/user/userinfo.dart';
import 'package:kicksy/view/user/usermain.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart' as http;

class PurchaseList extends StatefulWidget {
  const PurchaseList({super.key});

  @override
  State<PurchaseList> createState() => _PurchaseList();
}

class _PurchaseList extends State<PurchaseList> {
  DatabaseHandler handler = DatabaseHandler();
  late TextEditingController searchController;
  late Future<List<dynamic>> requestFuture;
  List request = [];
  var value = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    requestFuture = handler.queryRequest(value[0]);
    getJSONDataRequest();
  }

  String getStoreCode(int storeCode) {
    switch (storeCode) {
      case 1:
        return '강남구';
      case 2:
        return '강동구';
      case 3:
        return '강북구';
      case 4:
        return '강서구';
      case 5:
        return '관악구';
      case 6:
        return '광진구';
      case 7:
        return '구로구';
      case 8:
        return '금천구';
      case 9:
        return '노원구';
      case 10:
        return '도봉구';
      case 11:
        return '동대문구';
      case 12:
        return '동작구';
      case 13:
        return '마포구';
      case 14:
        return '서대문구';
      case 15:
        return '서초구';
      case 16:
        return '성동구';
      case 17:
        return '성북구';
      case 18:
        return '송파구';
      case 19:
        return '양천구';
      case 20:
        return '영등포구';
      case 21:
        return '용산구';
      case 22:
        return '은평구';
      case 23:
        return '종로구';
      case 24:
        return '중구';
      case 25:
        return '중랑구';
      default:
        return '알 수 없음';
    }
  }

  getJSONDataRequest() async {
    var responseDoc = await http.get(
      Uri.parse('http://127.0.0.1:8000/request/email=${value[0]}'),
    );
    request.clear();
    request.addAll(json.decode(utf8.decode(responseDoc.bodyBytes))['results']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                Stack(
                  children: [
                    Positioned(
                      top: 35,
                      child: Builder(
                        builder:
                            (context) => IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Color(0xFFFFBF1F),
                                size: 30,
                              ),
                              onPressed:
                                  () => Scaffold.of(context).openDrawer(),
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 28.0),
                      child: Center(
                        child: Image.asset('images/logo.png', width: 120),
                      ),
                    ),
                  ],
                ),
                const Text(
                  '주문내역',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: request.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 28.0),
                            child: Text(
                              '주문일자 : ${request[index]['req_date']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 28, 0),
                            child: Container(
                              width: 346,
                              height: 120,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                              "http://127.0.0.1:8000/image/view/name=${request[index]['name']}&img_num=0?t=${DateTime.now().millisecondsSinceEpoch}",
                                            ),
                                            fit: BoxFit.cover
                                    ),
                                  ),),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black.withOpacity(0.4),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '주문 번호 : ${request[index]['req_num']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Text(
                                                  '수령처 : ${getStoreCode(request[index]['store_str_code'])} 매장',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 200,
                                                  child: Text(
                                                    '제품명 : ${request[index]['name']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '결제 가격 : ₩ ${request[index]['req_count'] * request[index]['price']}    ',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      '개수 : ${request[index]['req_count']}개',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '상태',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              request[index]['req_type'] == 0
                                                  ? '구매완료'
                                                  : request[index]['req_type'] ==
                                                      1
                                                  ? '상품준비중'
                                                  : request[index]['req_type'] ==
                                                      2
                                                  ? '픽업 가능'
                                                  : '픽업 완료',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        drawer: Drawer(
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => Get.to(Userinfo()),
                child: UserAccountsDrawerHeader(
                  currentAccountPicture: Transform.scale(
                    scale: 1.3,
                    child: Image.asset('images/kicksy_white.png'),
                  ),
                  accountName: Text(
                    value[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                    '전화번호 : ${value[0]}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(color: Color(0xFFFFBF1F)),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text(
                  '메인',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => Get.to(Usermain(), arguments: [value[0]]),
              ),
              ListTile(
                leading: Icon(Icons.list_alt_rounded),
                title: Text(
                  '주문목록',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () => Get.to(PurchaseList(), arguments: [value[0]]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
