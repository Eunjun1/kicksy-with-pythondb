import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/view/hq/hq_main.dart';
import 'package:kicksy/view/user/signup.dart';
import 'package:kicksy/view/user/usermain.dart';
import 'package:http/http.dart' as http;
import 'package:kicksy/vm/database_handler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //property
  late TextEditingController userIDeditingController;
  late TextEditingController userPWeditingController;
  late DatabaseHandler handler;
  List userId = [];
  List userPw = [];
  List user = [];
  List empId = [];
  List empPw = [];
  List emp = [];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    userIDeditingController = TextEditingController();
    userPWeditingController = TextEditingController();
    getuserJSONData();
    getEmployeeJSONData();
  }

  getuserJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/user/');
    var response = await http.get(url);

    user.clear();
    userId.clear();
    userPw.clear();
    user.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
    setState(() {});
    // print(userPw);
    for (int i = 0; i< user.length; i++){
      userId.add(user[i]['email']);
      userPw.add(user[i]['password']);
    }
    setState(() {});
    // print(userId);
    // print(userPw);
  }

  getEmployeeJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/employee/');
    var response = await http.get(url);

    empId.clear();
    empPw.clear();
    emp.clear();
    emp.addAll(json.decode(utf8.decode(response.bodyBytes))['results']);
    setState(() {});
    // print(userPw);
    for (int i = 0; i< emp.length; i++){
      empId.add(emp[i]['emp_code']);
      empPw.add(emp[i]['password']);
    }
    setState(() {});
    print(empId);
    // print(empPw);
  }

  Future<void> _handleLogin() async {
    String id = userIDeditingController.text.trim();
    String pw = userPWeditingController.text.trim();

    if (id.isEmpty || pw.isEmpty) {
      Get.snackbar('입력 오류', '아이디와 비밀번호를 모두 입력하세요.');
      return;
    }

    // 유저 테이블 확인
    final userList = await handler.querySignINUser(id);
    if (userList.isNotEmpty) {
      final user = userList.first;
      if (user.password == userPw) {
        Get.to(Usermain(), arguments: [user.email]);
        userIDeditingController.clear();
        userPWeditingController.clear();
        return;
      } else {
        Get.snackbar('로그인 실패', '비밀번호가 틀렸습니다.');
        return;
      }
    }

    
    // 직원 테이블 확인
    final empList = await handler.querySignINEmp(id);
    if (empList.isNotEmpty) {
      final emp = empList.first;
      if (emp.password == pw) {
        Get.to(HqMain(), arguments: [emp.emp_code]);
        userIDeditingController.clear();
        userPWeditingController.clear();
        return;
      } else {
        Get.snackbar('로그인 실패', '비밀번호가 틀렸습니다.');
        return;
      }
    }

    // 둘 다 없음
    Get.snackbar('로그인 실패', '계정이 존재하지 않습니다.');
  }

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
                SizedBox(height: 50),
                //logo
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
                SizedBox(
                  //ID입력창
                  width: 350,
                  child: TextField(
                    controller: userIDeditingController,

                    decoration: InputDecoration(
                      labelText: 'ID',
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    //PW입력창
                    width: 350,
                    child: TextField(
                      controller: userPWeditingController,
                      decoration: InputDecoration(
                        // hintText: 'ID를입력하세요',
                        labelText: 'PW',
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
                      obscureText: true,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                  child: SizedBox(
                    width: 346,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        bool idvalue = userId.contains(userIDeditingController.text);
                        bool pwvalue = userPw.contains(userPWeditingController.text);
                        bool empidvalue = empId.contains(int.parse(userIDeditingController.text));
                        bool emppwvalue = empPw.contains(userPWeditingController.text);
                        // print(idvalue);
                        // print(pwvalue);
                        print(userIDeditingController.text);
                        print(empidvalue);
                        // print(emppwvalue);
                        if(idvalue && pwvalue){
                          Get.to(
                            Usermain(),
                            arguments: [
                              userIDeditingController.text
                            ]
                          );
                        }else if(empidvalue && emppwvalue){
                          Get.to(
                            HqMain(),
                            arguments: [
                              userIDeditingController.text
                            ]
                          );
                        }
                        else{
                          Get.snackbar('title', 'message');
                        }
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
  }
}
