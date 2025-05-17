  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:kicksy/model/product_with_model.dart';
  import 'package:kicksy/model/request.dart';
  import 'package:kicksy/view/user/mapview.dart';
  import 'package:kicksy/view/user/purchase_list.dart';

  import 'package:kicksy/vm/database_handler.dart';

  class UserPayment extends StatefulWidget {
    const UserPayment({super.key});

    @override
    State<UserPayment> createState() => _UserPaymentState();
  }

  class _UserPaymentState extends State<UserPayment> {
    DatabaseHandler databaseHandler = DatabaseHandler();

    late List<String> store;
    late int count;
    late String selectedStore;
    late TextEditingController textEditingController;
    late String userId;
    late int modelCode;
    late int selectedSize;
    late List<ProductWithModel> model;

    @override
    void initState() {
      super.initState();
      store = [
        '',
        '강남구',
        '강동구',
        '강북구',
        '강서구',
        '관악구',
        '광진구',
        '구로구',
        '금천구',
        '노원구',
        '도봉구',
        '동대문구',
        '동작구',
        '마포구',
        '서대문구',
        '서초구',
        '성동구',
        '성북구',
        '송파구',
        '양천구',
        '영등포구',
        '용산구',
        '은평구',
        '종로구',
        '중구',
        '중랑구',
      ];
      selectedStore = '';
      count = Get.arguments[1];
      textEditingController = TextEditingController();
      userId = Get.arguments[3];
      modelCode = Get.arguments[0];
      selectedSize = Get.arguments[4];
      model = List<ProductWithModel>.from(Get.arguments[2]);
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          toolbarHeight: 60,
          centerTitle: false,
          title: Text(
            '결제 정보',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.fromLTRB(28, 10, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '구매 상품',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Container(
                  width: 346,
                  height: 100,
                  child: Row(
                    children: [
                      FutureBuilder(
                        future: databaseHandler.queryImages(model[0].model.name),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              width: 90,
                              height: 90,

                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.memory(
                                  snapshot.data![0].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 190,
                              child: Text(
                                '모델 : ${model[0].model.name}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 190,
                              child: Text(
                                '색상 : ${model[0].model.color}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Text(
                              '사이즈 : $selectedSize',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                countUp();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.keyboard_arrow_up_sharp,
                                size: 30,
                              ),
                            ),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 24,
                                height: 24,
                                color: Color(0xffFFC01E),
                                child: Text(
                                  count.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                countDown();
                                setState(() {});
                              },
                              child: Icon(
                                Icons.keyboard_arrow_down_sharp,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0),
                    child: Text(
                      '₩ ${count * model[0].model.saleprice}',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(0, 28, 0, 20),
                child: Text(
                  '수령 매장 선택',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
              ),

              Container(
                width: 346,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 280,
                          height: 50,
                          child: TextField(
                            controller: textEditingController,
                            readOnly: true,
                            decoration: InputDecoration(
                              hintText: '매장을 선택하세요',
                              hintStyle: TextStyle(color: Color(0xffD9D9D9)),

                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xffFFC01E),
                                      size: 40,
                                    ),
                                    hint: SizedBox.shrink(), // 버튼 안에 아무것도 안 보이게 함
                                    items:
                                        store
                                            .where((s) => s.isNotEmpty)
                                            .map<DropdownMenuItem<String>>((
                                              String value,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            })
                                            .toList(),

                                    onChanged: (String? value) {
                                      selectedStore = value!;
                                      textEditingController.text = selectedStore;
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(color: Color(0xffD9D9D9)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Color(0xffD9D9D9),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    IconButton(
                      onPressed: () {
                        Get.to(() => UserMapview());
                      },
                      icon: Icon(
                        Icons.location_on,
                        size: 30,
                        color: Color(0xffFFC01E),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: SizedBox(
            width: 346,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (selectedStore.isEmpty) {
                  Get.snackbar(
                    "수령 매장 선택",
                    "수령매장을 선택해주세요.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                } else {
                  insertRequest();
                  Get.to(PurchaseList(), arguments: [userId]);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffFFC01E),
                foregroundColor: Colors.white,
              ),
              child: Text(
                '결제 하기',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      );
    }

    insertRequest() async{
      // id와 product코드 argument가져와서 고치기
      var insertreq = Request(
        userId: userId,
        productCode: model[0].product.code!,
        storeCode: getStoreCode(),
        type: 0,
        date: DateTime.now().toString(),
        count: count,
      );
      await databaseHandler.insertRequest(insertreq);
    }

    getStoreCode() {
      int storeCode = 0;
      switch (selectedStore) {
        case ('강남구'):
          storeCode = 1;
        case ('강동구'):
          storeCode = 2;
        case ('강북구'):
          storeCode = 3;
        case ('강서구'):
          storeCode = 4;
        case ('관악구'):
          storeCode = 5;
        case ('광진구'):
          storeCode = 6;
        case ('구로구'):
          storeCode = 7;
        case ('금천구'):
          storeCode = 8;
        case ('노원구'):
          storeCode = 9;
        case ('도봉구'):
          storeCode = 10;
        case ('동대문구'):
          storeCode = 11;
        case ('동작구'):
          storeCode = 12;
        case ('마포구'):
          storeCode = 13;
        case ('서대문구'):
          storeCode = 14;
        case ('서초구'):
          storeCode = 15;
        case ('성동구'):
          storeCode = 16;
        case ('성북구'):
          storeCode = 17;
        case ('송파구'):
          storeCode = 18;
        case ('양천구'):
          storeCode = 19;
        case ('영등포구'):
          storeCode = 20;
        case ('용산구'):
          storeCode = 21;
        case ('은평구'):
          storeCode = 22;
        case ('종로구'):
          storeCode = 23;
        case ('중구'):
          storeCode = 24;
        case ('중랑구'):
          storeCode = 25;
      }
      return storeCode;
    }

    countUp() {
      count += 1;
    }

    countDown() {
      if (count == 1) {
        count = 1;
      } else {
        count -= 1;
      }
    }
  }
