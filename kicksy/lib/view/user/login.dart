import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/model/user.dart';
import 'package:kicksy/view/hq/hq_main.dart';
import 'package:kicksy/view/user/signup.dart';
import 'package:kicksy/view/user/usermain.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart'as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //property
  List<String> data  = [];
  late TextEditingController userIDeditingController = TextEditingController();
  late TextEditingController userPWeditingController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    getJSONData();
  }
  getJSONData()async{
    var response = await http.get(Uri.parse('http://127.0.0.1:8000/user/'));
    data.clear();
    data.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
    // print(data);
    setState(() {});
  }

  // Future<void> _handleLogin() async {
  //   String id = userIDeditingController.text.trim();
  //   String pw = userPWeditingController.text.trim();

    // if (id.isEmpty || pw.isEmpty) {
    //   Get.snackbar('입력 오류', '아이디와 비밀번호를 모두 입력하세요.');
    //   return;
    // }

    // // 유저 테이블 확인
    // final userList = await handler.querySignINUser(id);
    // if (userList.isNotEmpty) {
    //   final user = userList.first;
    //   if (user.password == pw) {
    //     Get.to(Usermain(), arguments: [user.email]);
    //     userIDeditingController.clear();
    //     userPWeditingController.clear();
    //     return;
    //   } else {
    //     Get.snackbar('로그인 실패', '비밀번호가 틀렸습니다.');
    //     return;
    //   }
    // }

    // // 직원 테이블 확인
    // final empList = await handler.querySignINEmp(id);
    // if (empList.isNotEmpty) {
    //   final emp = empList.first;
    //   if (emp.password == pw) {
    //     Get.to(HqMain(), arguments: [emp.emp_code]);
    //     userIDeditingController.clear();
    //     userPWeditingController.clear();
    //     return;
    //   } else {
    //     Get.snackbar('로그인 실패', '비밀번호가 틀렸습니다.');
    //     return;
    //   }
    // }

  //   // 둘 다 없음
  //   Get.snackbar('로그인 실패', '계정이 존재하지 않습니다.');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                SizedBox(height: 50),
                Image.asset('images/logo.png', width: 350),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: 350,
                    child: Row(
                      children: [
                        Text(
                          //font는 pretendard로 바꾸기
                          'Login to your Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF727272), // 0xFF+727272
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //   //ID입력창
                _buildTextfield(userIDeditingController, 'ID'),
                _buildTextfield(userPWeditingController, 'PW'),
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: SizedBox(
                    width: 346,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // if(userIDeditingController.text == ){

                        // }
                        Get.to(Usermain());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFFBF1F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(350, 40),
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  width: 350,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '계정이 없으신가요?',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD9D9D9),
                        ),
                      ),
                      //회원가입버튼
                      TextButton(
                        onPressed: () {
                          Get.to(Signup());
                        },
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFBF1F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }//build

  //----wigget----
  Widget _buildTextfield(TextEditingController controller, String labelText){
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0,10),
      child: SizedBox(
        width: 350,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
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
        ),
      ),
    );

  }


  //----function----

}//class
