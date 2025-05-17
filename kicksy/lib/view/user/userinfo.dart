import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/model/user.dart';
import 'package:kicksy/view/user/purchase_list.dart';

import '../../vm/database_handler.dart';
import 'usermain.dart';

class Userinfo extends StatefulWidget {
  const Userinfo({super.key});

  @override
  State<Userinfo> createState() => _UserinfoState();
}

class _UserinfoState extends State<Userinfo> {
  late DatabaseHandler handler;
  late TextEditingController userIDController; //ID
  late TextEditingController userPWController; //PW
  // late TextEditingController userPWcheckController; //PWcheck
  late TextEditingController userPhoneController; //전화번호
  late TextEditingController userAddressController; //주소
  late TextEditingController userDetail_AddressController; //상세주소
  late List<String> userSex;
  late String dropDownValue; //dropdown

  var value = Get.arguments ?? "__";

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    userIDController = TextEditingController();
    userPWController = TextEditingController();
    // userPWcheckController = TextEditingController();
    userPhoneController = TextEditingController();
    userAddressController = TextEditingController();
    userDetail_AddressController = TextEditingController();
    userSex = ['무관', '남성', '여성'];
    dropDownValue = userSex[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: handler.querySignINUser(value[0]),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  SizedBox(height: 50),

                  //우측상단 logo
                  Stack(
                    children: [
                      Center(child: Image.asset('images/logo.png', width: 120)),
                    ],
                  ),
                  Container(
                    width: 350,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '회원정보',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //email
                  SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: userIDController,
                          decoration: InputDecoration(
                            hintText: snapshot.data![0].email,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF727272)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              //입력 비활성화됐을때
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF727272)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFFFFBF1F)),
                            ),
                          ),
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),

                  //PW
                  SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '비밀번호',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: userPWController,
                          decoration: InputDecoration(
                            hintText: snapshot.data![0].password,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF727272)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              //입력 비활성화됐을때
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF727272)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFFFFBF1F)),
                            ),
                          ),
                          readOnly: false,
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),

                  // //PW check
                  // SizedBox(
                  //   width: 350,
                  //   child: Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Text('비밀번호확인',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,)),
                  //           ],
                  //         ),
                  //       ),
                  //       TextField(
                  //         controller: userPWcheckController,
                  //         decoration: InputDecoration(
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(20),
                  //             borderSide: BorderSide(color: Color(0xFF727272)),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             //입력 비활성화됐을때
                  //             borderRadius: BorderRadius.circular(20),
                  //             borderSide: BorderSide(color: Color(0xFF727272)),
                  //           ),
                  //           focusedBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(20),
                  //             borderSide: BorderSide(color: Color(0xFFFFBF1F)),
                  //           ),
                  //         ),
                  //         readOnly: false,
                  //         obscureText: true,
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  //PW check
                  SizedBox(
                    width: 350,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '전화번호',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: userPhoneController,
                          decoration: InputDecoration(
                            hintText: snapshot.data![0].phone,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF727272)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              //입력 비활성화됐을때
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFF727272)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xFFFFBF1F)),
                            ),
                          ),
                          readOnly: false,
                        ),
                      ],
                    ),
                  ),
                  //성별 선택
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SizedBox(
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 55,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF727272),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(snapshot.data![0].sex),
                                ),
                                DropdownButton(
                                  iconEnabledColor: Color(0xFFFFBF1F),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 28,
                                  ), //꺾쇠아이콘
                                  value: dropDownValue,
                                  items:
                                      userSex.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    dropDownValue = value!;
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        updateUser();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFBF1F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(350, 40),
                      ),
                      child: Text(
                        '수정',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(350, 40),
                      ),
                      child: Text(
                        '취소',
                        style: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),

      //drawer
    );
  }

  updateUser() async {
    int result = 0;
    if (userPWController.text.isNotEmpty &&
        userPhoneController.text.isNotEmpty) {
      var userUpdate = User(
        email: value[0],
        password: userPWController.text,
        phone: userPhoneController.text,
        address: '',
        signupdate: '',
        sex: dropDownValue,
      );
      result = await handler.updateUser(userUpdate);
    } else {
      errorinputSnackbar();
    }

    if (result == 0) {
      errorSnackbar();
    } else {
      _showDialog();
    }
  }

  _showDialog() {
    Get.defaultDialog(
      title: '수정 완료',
      middleText: '수정이 완료되었습니다.',
      titleStyle: TextStyle(color: Colors.white),
      middleTextStyle: TextStyle(color: Colors.white),
      backgroundColor: Color(0xFFFFBF1F),
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  errorSnackbar() {
    Get.snackbar(
      '경고',
      '입력 중 문제가 발생 하였습니다',
      colorText: Theme.of(context).colorScheme.onErrorContainer,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      duration: Duration(seconds: 1),
    );
  }

  errorinputSnackbar() {
    Get.snackbar(
      '경고',
      '다시 입력해주세요',
      colorText: Theme.of(context).colorScheme.onErrorContainer,
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
    );
  }
}
