import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/vm/database_handler.dart';

class HqModelDetail extends StatefulWidget {
  const HqModelDetail({super.key});

  @override
  State<HqModelDetail> createState() => _HqModelDetailState();
}

class _HqModelDetailState extends State<HqModelDetail> {
  late DatabaseHandler handler;
  late Uint8List modeliamge;

  var value = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    modeliamge = value[2];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: handler.queryProductwithImageModel(value[0], value[1]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              
              return Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    '상세정보',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 230,
                    width: 230,
                    child: Image.memory(modeliamge, width: 200),
                  ),
                  FutureBuilder(
                    future: handler.queryImages(value[0]),
                    builder: (context, snapshotimage) {
                      if (snapshotimage.hasData) {
                        return SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshotimage.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  modeliamge = snapshotimage.data![index].image;
                                  setState(() {});
                                },
                                child: Image.memory(
                                  snapshotimage.data![index].image,
                                  width: 100,
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),

                  Text('이름 : ${snapshot.data![0].model.name}'),
                  Text('카테고리 : ${snapshot.data![0].model.category}'),
                  Text('제조사 : ${snapshot.data![0].model.company}'),
                  Text('색상 : ${snapshot.data![0].model.color}'),
                  Text('가격 : ${snapshot.data![0].model.saleprice.toString()}'),
                  Text('사이즈 목록'),
                  SizedBox(
                    width: 300,
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        childAspectRatio: 1.0,
                      ),
                      itemBuilder: (context, index) {
                        var prodMaxStock = snapshot.data![index].product.maxstock;

                        return Center(
                          child: Column(
                            children: [
                              Text(
                                snapshot.data![index].product.size.toString(),
                              ),
                          FutureBuilder(
                            future: handler.queryRequestWithProduct(snapshot.data![index].product.size),
                            builder: (context, snapshot) {
                              
                              if(snapshot.hasData){
                              int sum =0;
                              if(snapshot.data!.isNotEmpty){
                              for(int i = 0; i<snapshot.data!.length;i++){
                                sum +=  snapshot.data![i].count;
                                
                              }
                              
                              }
                            return 
                            Column(
                              children: [
                                Text('${sum.toString()}/$prodMaxStock'),
                                sum>=prodMaxStock*0.7?Text('발주요망',style: TextStyle(color: Colors.red),):Text(''),
                              ],
                            );
                            
                            }else{
                              return Center(child: CircularProgressIndicator(),);
                            }
                            
                            }
                            
                            ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Text('재고량 : ${snapshot.data![0].product.maxstock}'),
                  Text(
                    '등록 날짜 : ${snapshot.data![0].product.registration.substring(0, 10)}',
                  ),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text('확인'),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
