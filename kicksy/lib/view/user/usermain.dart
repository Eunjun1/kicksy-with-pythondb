import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:kicksy/model/product.dart';
import 'package:kicksy/view/user/login.dart';
import 'package:kicksy/view/user/purchase.dart';
import 'package:kicksy/view/user/purchase_list.dart';
import 'package:kicksy/view/user/userinfo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

class Usermain extends StatefulWidget {
  const Usermain({super.key});

  @override
  State<Usermain> createState() => _UsermainState();
}

class _UsermainState extends State<Usermain> {

  List prodList = [];
  List modList = [];
  List companyList = [];
  List modelWithImageList = [];
  List imageList = [];
  late String searchname;
  late String searchCompany;

  // DatabaseHandler handler = DatabaseHandler();
  late TextEditingController searchController;
  int selectedIndex = -1;

  var email = 1; //Get.arguments[0] ?? "__";
  var value = Get.arguments ?? "__";
  // late dynamic newProdCategory;
  // late dynamic newProdCompany;

  @override
  void initState() {
    super.initState();
    // handler = DatabaseHandler();
    searchController = TextEditingController();
    searchname = '';
    searchCompany = '';
    getProdJSONData();
    getModelJSONData();
    getCompanyJSONData();
    getImageJSONData();
    getModelWithImageJSONData(searchname,searchCompany);
  }

  getProdJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/product/select');
    var response = await http.get(url);

    prodList.clear();
    prodList.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
    setState(() {});
  }

  getModelJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/model/selectAll');
    var response = await http.get(url);

    modList.clear();
    modList.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
    setState(() {});
  }

  getCompanyJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/model/select/company');
    var response = await http.get(url);

    companyList.clear();
    companyList.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
    setState(() {});
  }

  getImageJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/image/select');
    var response = await http.get(url);

    imageList.clear();
    imageList.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
    setState(() {});
  }
  

  getModelWithImageJSONData(String name , String company) async {
    var url = Uri.parse('http://127.0.0.1:8000/model/modelWithImage/?name=$name&company=$company');
    var response = await http.get(url);

    if (response.statusCode == 200) {
    modelWithImageList.clear();
    modelWithImageList.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
    setState(() {});
  }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
                  child: GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 60),
                          //우측상단 logo
                          Stack(
                            children: [
                              Positioned(
                                top: 35,
                                child: Builder(
                                  builder:
                                      (context) => IconButton(
                                        icon: Transform.scale(
                                          scale: 1.2,
                                          child: Icon(
                                            Icons.menu,
                                            color: Color(0xFFFFBF1F),
                                          ),
                                        ),
                                        onPressed: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                      ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 28.0),
                                child: Center(
                                  child: Transform.scale(
                                    scale: 1.2,
                                    child: Image.asset(
                                      'images/logo.png',
                                      width: 120,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 30,
                                height: 120,
                                child: IconButton(
                                  onPressed: () => Get.to(Login()),
                                  icon: Icon(Icons.logout_outlined),
                                  color: Color(0xFFFFBF1F),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: SizedBox(
                              //상품검색 입력창
                              width: 346,
                              height: 50,
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) async {
                                  if (selectedIndex == -1) {
                                    searchname =
                                        searchController.text;
                                  } else {
                                    searchCompany =
                                        companyList[selectedIndex];
                                  }
                                  setState(() {});
                                  getModelWithImageJSONData(searchController.text, searchCompany);
                                },
                                decoration: InputDecoration(
                                  //search icon
                                  label: Icon(
                                    Icons.search,
                                    size: 30,
                                    color: Color(0xffD9D9D9),
                                  ),

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(0xFF727272),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    //입력 비활성화됐을때
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(0xffD9D9D9),
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                      color: Color(0xFFFFBF1F),
                                    ),
                                  ),
                                ),

                                //비밀번호 안보이게
                              ),
                            ),
                          ),

                          //container내부에 사진 들어가기
                          Stack(
                            children: [
                              // Container(
                              //   width: 346,
                              //   height: 174,
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(20),
                              //     image: DecorationImage(
                              //       image: NetworkImage(
                              //         'http://127.0.0.1:8000/image/${modelWithImageList[0]['model_num']}?t=${DateTime.now().millisecondsSinceEpoch}'
                              //         ),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // ),

                              Container(
                                width: 346,
                                height: 174,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(
                                    0.3,
                                  ), // 검정색 투명도 30%
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 28.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'New Product',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 40,
                                          color: Colors.white,
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10.0,
                                        ),
                                        child: Row(
                                          children: [
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //     top: 10.0,
                                            //   ),
                                            //   child: Text(
                                            //     '$newProdCompany  ',
                                            //     style: TextStyle(
                                            //       fontWeight: FontWeight.w700,
                                            //       fontSize: 30,
                                            //       color: Colors.white,
                                            //     ),
                                            //   ),
                                            // ),
                                            // Text(
                                            //   newProdCategory,
                                            //   style: TextStyle(
                                            //     fontWeight: FontWeight.w700,
                                            //     fontSize: 45,
                                            //     color: Colors.white,
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 0, 5),
                            child: Text(
                              '카테고리',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          SizedBox(
                                  height: 40,
                                  width: 400,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          5,
                                          4,
                                          5,
                                          4,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            searchController.clear();
                                            searchname = '';
                                            searchCompany = '';
                                            setState(() {
                                            });
                                            getModelWithImageJSONData(searchname, searchCompany);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            side: BorderSide(
                                              color: Color(0xffFFBF1F),
                                            ),
                                            backgroundColor:
                                                selectedIndex == -1
                                                    ? Colors.white
                                                    : Color(0xffFFBF1F),
                                          ),
                                          child: Text(
                                            '전체 보기',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  selectedIndex == -1
                                                      ? Colors.black
                                                      : Color(0xFFD09D1D),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...List.generate(companyList.length, (
                                        index,
                                      ) {
                                        final isSelected =
                                            selectedIndex == index;
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            5,
                                            4,
                                            5,
                                            4,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              searchController.clear();
                                              searchCompany =
                                                  companyList[selectedIndex + 1]['company'];
                                              setState(() {
                                                selectedIndex = index;
                                              });
                                              getModelWithImageJSONData(searchname, searchCompany);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              side: BorderSide(
                                                color: Color(0xffFFBF1F),
                                              ),
                                              backgroundColor:
                                                  isSelected
                                                      ? Colors.white
                                                      : Color(0xffFFBF1F),
                                            ),
                                            child: Text(
                                              companyList[index]['company'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    isSelected
                                                        ? Colors.black
                                                        : Color(0xFFD09D1D),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              width: 353,
                              child: GridView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: modelWithImageList.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 25,
                                      mainAxisSpacing: 25,
                                      childAspectRatio:
                                          1 / 1.4, //gridview 가로세로 비율
                                    ),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap:
                                        () => Get.to(
                                          Purchase(),
                                          arguments: [
                                            modelWithImageList[index]['name'],
                                            email,
                                          ],
                                        ),
                                    child: SizedBox(
                                      width: 160,
                                      height: 217,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Card(
                                          color: Color(0xffFFBF1F),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            5.0,
                                                          ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              5.0,
                                                            ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                20,
                                                              ),
                                                          child: Image.network(
                                                            'http://127.0.0.1:8000/image/${modelWithImageList[index]['model_num']}?t=${DateTime.now().millisecondsSinceEpoch}',
                                                            width: 148,
                                                            height: 131,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  //제조사
                                                                  modelWithImageList[index]['company'],
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Text(
                                                                  //상품이름
                                                                  modelWithImageList[index]['name'],
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                                Text(
                                                                  //가격
                                                                  '₩ ${modelWithImageList[index]['saleprice'].toString()}',
                                                                  style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
        ),
        //drawer
        // drawer: FutureBuilder(
        //   future: handler.querySignINUser(email),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return Drawer(
        //         child: ListView(
        //           children: [
        //             GestureDetector(
        //               onTap:
        //                   () => Get.to(Userinfo(), arguments: [email])!.then((
        //                     value,
        //                   ) {
        //                     reloaduser(email);
        //                   }),
        //               child: UserAccountsDrawerHeader(
        //                 currentAccountPicture: Transform.scale(
        //                   scale: 1.3,
        //                   child: Image.asset('images/kicksy_white.png'),
        //                 ),

        //                 // otherAccountsPictures: [
        //                 //   CircleAvatar(backgroundImage: AssetImage('images/logo.png')),
        //                 //   CircleAvatar(backgroundImage: AssetImage('images/logo.png')),
        //                 // ],
        //                 accountName: Text(
        //                   snapshot.data![0].email,
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //                 accountEmail: Text(
        //                   '전화번호 : ${snapshot.data![0].phone}',
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //                 decoration: BoxDecoration(
        //                   color: Color(0xFFFFBF1F),
        //                   // borderRadius: BorderRadius.only(
        //                   //   bottomLeft: Radius.circular(40),
        //                   //   bottomRight: Radius.circular(40),
        //                   // ),
        //                 ),
        //               ),
        //             ),
        //             ListTile(
        //               leading: Icon(Icons.home_outlined),
        //               title: Text(
        //                 '메인',
        //                 style: TextStyle(
        //                   fontSize: 17,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               onTap: () {
        //                 Get.to(Usermain(), arguments: [email]);
        //                 // print('home is clicked');
        //               },
        //             ),
        //             ListTile(
        //               leading: Icon(Icons.list_alt_rounded),
        //               title: Text(
        //                 '주문목록',
        //                 style: TextStyle(
        //                   fontSize: 17,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //               onTap: () {
        //                 Get.to(PurchaseList(), arguments: [email]);
        //                 // print('home is clicked');
        //               },
        //             ),
        //           ],
        //         ),
        //       );
        //     } else {
        //       return Center(child: CircularProgressIndicator());
        //     }
        //   },
        // ),
      ),
    );
  } //build

} //class
