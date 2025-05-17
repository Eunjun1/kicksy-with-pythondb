import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:kicksy/view/hq/hq_document.dart';
import 'package:kicksy/view/hq/hq_insert.dart';
import 'package:kicksy/view/hq/hq_insert_order_document.dart';
import 'package:kicksy/view/hq/hq_model_detail.dart';
import 'package:kicksy/view/hq/hq_request_list.dart';
import 'package:kicksy/vm/database_handler.dart';

class HqMain extends StatefulWidget {
  const HqMain({super.key});

  @override
  State<HqMain> createState() => _HqMainState();
}

class _HqMainState extends State<HqMain> {
  //property
  DatabaseHandler handler = DatabaseHandler();
  late List<String> productList;
  var value = Get.arguments[0] ?? "__";

  ///
  late String dropDownValue;

  @override
  void initState() {
    super.initState();
    productList = ['제품 목록', '발주 목록'];
    dropDownValue = productList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: handler.queryEmployee(value),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
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
                            snapshot.data![0].division,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          snapshot.data![0].grade,
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
                          width: 250,
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
                                            150,
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
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(HqRequestList(), arguments: [value]);
                            },
                            child: Text('주문내역'),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child:
                          dropDownValue == '제품 목록'
                              ? FutureBuilder(
                                future: handler.queryModelwithImage(''),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(
                                              HqModelDetail(),
                                              arguments: [
                                                snapshot
                                                    .data![index]
                                                    .model
                                                    .name,
                                                snapshot
                                                    .data![index]
                                                    .model
                                                    .code,
                                                snapshot.data![0].images.image,
                                              ],
                                            );
                                          },
                                          child: Card(
                                            child: Row(
                                              children: [
                                                Image.memory(
                                                  snapshot
                                                      .data![index]
                                                      .images
                                                      .image,
                                                  width: 100,
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      '모델명 : ${snapshot.data![index].model.name}',
                                                    ),
                                                    Text(
                                                      '제조사 : ${snapshot.data![index].model.company}',
                                                    ),
                                                    Text(
                                                      '가격 : ${snapshot.data![index].model.saleprice}',
                                                    ),
                                                  ],
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
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              )
                              : FutureBuilder(
                                future: handler.queryOderyingWithDocument(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Column(
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
                                          itemCount: snapshot.data!.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap:
                                                  () => Get.to(
                                                    () => HqDocument(),
                                                    arguments: [
                                                      snapshot
                                                          .data![index]
                                                          .document
                                                          .code,
                                                      value,
                                                    ],
                                                  )!.then(
                                                    (value) => reloadData(),
                                                  ),
                                              child: Card(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data![index]
                                                          .orderying
                                                          .num
                                                          .toString(),
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data![index]
                                                          .document
                                                          .title,
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data![index]
                                                          .document
                                                          .propser,
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data![index]
                                                          .document
                                                          .date
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
                                    );
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                },
                              ),
                    ),
                  ],
                ), // FutureBuilder
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton:
          dropDownValue == '제품 목록'
              ? IconButton(
                onPressed:
                    () =>
                        Get.to(() => HqInsert())!.then((value) => reloadData()),
                icon: Icon(Icons.add),
              )
              : IconButton(
                onPressed:
                    () => Get.to(
                      HqInsertOrderDocument(),
                      arguments: [value],
                    )!.then((value) => reloadData()),
                icon: Icon(Icons.add),
              ),
    );
  }

  reloadData() async {
    handler.queryModelwithImage('');
    handler.queryOderyingWithDocument();
    setState(() {});
  }
}
