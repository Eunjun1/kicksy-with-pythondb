import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/model/images.dart';
import 'package:kicksy/model/model.dart';
import 'package:kicksy/model/product_with_model.dart';
import 'package:kicksy/view/user/payment.dart';

import 'package:kicksy/vm/database_handler.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

class Purchase extends StatefulWidget {
  const Purchase({super.key});

  @override
  State<Purchase> createState() => _PurchaseState();
}

class _PurchaseState extends State<Purchase> {
  DatabaseHandler handler = DatabaseHandler();
  late List<ProductWithModel> data;
  late List<Images> imageData;
  late int imageCurrent;
  late int buyCount;
  late List<Model> sameCategory;
  late int productCode;
  late int selectedSize;
  String modelName = Get.arguments[0] ?? "__";
  String userId = Get.arguments[1];

  @override
  void initState() {
    super.initState();
    data = [];
    imageData = [];
    sameCategory = [];
    imageCurrent = 0;
    buyCount = 1;
    productCode = 0;
    selectedSize = 0;
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    await fetchData();
    await fetchImageData();

    await fetchsameCategory(); // data[0] 접근은 fetchData가 끝난 뒤에만
    setState(() {});
  }

  Future<void> fetchData() async {
    List<ProductWithModel> fetchData = await handler.queryProductwithModel(
      modelName,
    );
    data = fetchData;
    setState(() {});
  }

  Future<void> fetchImageData() async {
    List<Images> fetchImageData = await handler.queryImages(modelName);

    imageData = fetchImageData;
    setState(() {});
  }

  Future<void> fetchsameCategory() async {
    List<Model> fetchData = await handler.queryModelWhereCategory(
      data[0].model.category,
    );
    sameCategory = fetchData;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        centerTitle: false,
        title: Text(
          '구매하기',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
        ),
      ),

      body:
          data.isEmpty && imageData.isEmpty
              ? Center(child: CircularProgressIndicator()) // 로딩 중
              : Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 0, 0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data[0].model.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xffFFC01E),
                                  fontSize: 40,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                child: Text(
                                  data[0].model.company,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 22,
                                  ),
                                ),
                              ),

                              Text(
                                data[0].model.category,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),

                              imageData.isEmpty || data.isEmpty
                                  ? SizedBox(
                                    width: 346,
                                    height: 250,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                  : ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: SimpleGestureDetector(
                                      onHorizontalSwipe: (direction) {
                                        direction == SwipeDirection.left
                                            ? {
                                              imageCurrent += 1,
                                              if (imageCurrent >
                                                  imageData.length - 1)
                                                {
                                                  imageCurrent = 0,
                                                  setState(() {}),
                                                },
                                            }
                                            : {
                                              imageCurrent -= 1,
                                              if (imageCurrent < 0)
                                                {
                                                  imageCurrent =
                                                      imageData.length - 1,
                                                  setState(() {}),
                                                },
                                            };

                                        setState(() {});
                                      },

                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          0,
                                          10,
                                          0,
                                          18,
                                        ),
                                        child: Container(
                                          width: 346,
                                          height: 250,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: MemoryImage(
                                                imageData[imageCurrent].image,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                              Text(
                                '₩ ${data[0].model.saleprice}',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  10,
                                  0,
                                  10,
                                ),
                                child: Text(
                                  '이런 상품 어떠세요?',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 354,
                                height: 70,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: sameCategory.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        modelName = sameCategory[index].name;
                                        fetchAllData();
                                        setState(() {});
                                      },

                                      child: SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Card(
                                          child: Center(
                                            child: Text(
                                              sameCategory[index].color,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  0,
                                  10,
                                  0,
                                  10,
                                ),
                                child: Text(
                                  '사이즈',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 100,
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 1 / 2,
                                      ),

                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final isSelected =
                                        productCode == data[index].product.code;

                                    return SizedBox(
                                      width: 95,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedSize =
                                                  data[index].product.size;
                                              productCode =
                                                  data[index].product.code!;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                isSelected
                                                    ? Color(0xffFFC01E)
                                                    : Color(0xffE7E7E7),
                                            foregroundColor:
                                                isSelected
                                                    ? Colors.white
                                                    : Color(0xffC7C1C1),
                                          ),
                                          child: Text(
                                            data[index].product.size.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(
                                  '개수',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 30,
                                    width: 50,

                                    child: IconButton(
                                      onPressed: () {
                                        if (buyCount > 1) {
                                          buyCount -= 1;
                                        } else {
                                          buyCount = 1;
                                        }

                                        setState(() {});
                                      },
                                      icon: Icon(Icons.arrow_back_ios),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      10,
                                      15,
                                      0,
                                    ),
                                    child: Text(
                                      buyCount.toString(),
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    width: 50,
                                    height: 30,
                                    child: IconButton(
                                      onPressed: () {
                                        if (buyCount < 5) {
                                          buyCount += 1;
                                        } else {
                                          buyCount = 5;
                                        }
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 150),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 52,
                    left: 28,
                    child: SizedBox(
                      width: 346,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (productCode == 0) {
                            // 사이즈 선택 안됨
                            Get.snackbar(
                              "사이즈 선택",
                              "사이즈를 선택해주세요.",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          // 구매 버튼 - 사이즈가 선택된 경우만 이동
                          Get.to(
                            UserPayment(),
                            arguments: [
                              productCode,
                              buyCount,
                              data,
                              userId,
                              selectedSize,
                            ],
                          );
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "₩ ${data[0].model.saleprice * buyCount}",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
