import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

class HqModelDetail extends StatefulWidget {
  const HqModelDetail({super.key});

  @override
  State<HqModelDetail> createState() => _HqModelDetailState();
}

class _HqModelDetailState extends State<HqModelDetail> {
  List model = [];
  List product = [];
  List request = [];

  List count = [];
  String modelImage = "";
  var value = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();
    getJSONDataModel(value[1]);
    getJSONDataProd(value[1]);
    getJSONDataImg(value[0]);
    modelImage = 'http://127.0.0.1:8000/image/view/name=${value[0]}&img_num=0';
  }
  

  getJSONDataModel(int code) async {
    var responseModel = await http.get(
      Uri.parse('http://127.0.0.1:8000/model/$code'),
    );
    model.clear();
    model.addAll(json.decode(utf8.decode(responseModel.bodyBytes))['results']);
    setState(() {});
    print(model);
  }

  getJSONDataProd(int code) async {
    var responseProd = await http.get(
      Uri.parse('http://127.0.0.1:8000/product/mod_code=$code'),
    );
    product.clear();
    product.addAll(json.decode(utf8.decode(responseProd.bodyBytes))['results']);
    setState(() {});
    print(product);
  }

  getJSONDataImg(String name) async {
    var responsecount = await http.get(
      Uri.parse('http://127.0.0.1:8000/image/name=$name'),
    );
    count.clear();
    count.addAll(json.decode(utf8.decode(responsecount.bodyBytes))['results']);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return model.isEmpty & product.isEmpty & request.isEmpty & count.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
          body: 
          model.isEmpty & product.isEmpty & request.isEmpty & count.isEmpty
          ?Center(child: CircularProgressIndicator())
          :SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 80),
                Text(
                  '상세정보',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 230,
                  width: 230,
                  child: Image.network(modelImage),
                ),
                SizedBox(
                  height: 110,
                  child: 
                  count.isEmpty 
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: count.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          modelImage =
                              'http://127.0.0.1:8000/image/view/name=${value[0]}&img_num=${count[index]['img_num']}';
                          setState(() {});
                        },
                        child: Image.network(
                          'http://127.0.0.1:8000/image/view/name=${value[0]}&img_num=${count[index]['img_num']}',
                          width: 100,
                        ),
                      );
                    },
                  ),
                ),

                Text('이름 : ${model[0]['name']}'),
                Text('카테고리 : ${model[0]['category']}'),
                Text('제조사 : ${model[0]['company']}'),
                Text('색상 : ${model[0]['color']}'),
                Text('가격 : ${model[0]['saleprice'].toString()}'),
                Text('사이즈 목록'),

                SizedBox(
                  width: 300,
                  child: 
                  product.isEmpty
                  ?Center(child: CircularProgressIndicator())
                  :GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: product.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      var prodMaxStock = product[index]['maxstock'];
                      // getJSONDataRequest(product[index]['prod_code']);

                      int sum = prodMaxStock;
                      // int sale = request[0]['req_count'];
                      // sum -= sale;
                      return Center(
                        child: Column(
                          children: [
                            Text(product[index]['size'].toString()),
                            Column(
                              children: [
                                Text('/$prodMaxStock'),
                                sum <= prodMaxStock * 0.3
                                    ? Text(
                                      '발주요망',
                                      style: TextStyle(color: Colors.red),
                                    )
                                    : Text(''),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Text('재고량 : ${product[0]['maxstock']}'),
                Text('등록 날짜 : ${product[0]['registration'].substring(0, 10)}'),
                ElevatedButton(onPressed: () => Get.back(), child: Text('확인')),
              ],
            ),
          ),
        );
  }

  getJSONDataRequest(int code) async {
    var responseReq = await http.get(
      Uri.parse('http://127.0.0.1:8000/request/prod_code=$code'),
    );
    request.clear();
    request.addAll(json.decode(utf8.decode(responseReq.bodyBytes))['results']);
    setState(() {});
  }
}
