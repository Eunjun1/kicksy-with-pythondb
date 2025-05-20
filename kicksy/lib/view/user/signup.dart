import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kicksy/model/user.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late DatabaseHandler handler;
  late TextEditingController userIDController; //ID
  late TextEditingController userPWController; //PW
  late TextEditingController userPhoneController; //전화번호
  late TextEditingController userAddressController; //주소
  late TextEditingController userDetail_AddressController; //상세주소
  late List<String> userSex;
  late bool canUseId;
  late String dropDownValue; //dropdown

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    userIDController = TextEditingController();
    userPWController = TextEditingController();
    userPhoneController = TextEditingController();
    userAddressController = TextEditingController();
    userDetail_AddressController = TextEditingController();
    userSex = ['무관', '남성', '여성'];
    dropDownValue = userSex[0];
    canUseId = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: FutureBuilder(
            future: handler.querySignUP(userIDController.text),
            builder: (context, snapshot) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 380,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                        Padding(
                          //우측 상단 로고
                          padding: const EdgeInsets.fromLTRB(0, 30, 10, 30),
                          child: Image.asset('images/logo.png', width: 120),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: SizedBox(
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '정보 입력',
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: SizedBox(
                      //userEmail 입력
                      width: 350,
                      child: TextField(
                        controller: userIDController,
                        onChanged: (value) {
                          canUseId = true;
                          setState(() {});
                          reloadData(userIDController.text);
                        },
                        decoration: InputDecoration(
                          // hintText: 'ID를입력하세요',
                          labelText: 'Email',
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: SizedBox(
                      //userID일치 여부
                      width: 350,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                            visible: canUseId,
                            child:
                                userIDController.text.isNotEmpty &&
                                        snapshot.hasData &&
                                        snapshot.data != null &&
                                        snapshot.data!.isNotEmpty &&
                                        snapshot.data![0].email.isNotEmpty
                                    ? userIDController.text ==
                                            snapshot.data![0].email
                                        ? Text(
                                          '사용 불가한 아이디입니다.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.error,
                                          ),
                                        )
                                        : Text(
                                          '사용 가능한 아이디입니다.',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                          )
                                    : Text(
                                      '사용 가능한 아이디입니다.',
                                      style: TextStyle(
                                            color: Colors.green,
                                          ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: SizedBox(
                      //userPW 입력
                      width: 350,
                      child: TextField(
                        controller: userPWController,
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
                        //비밀번호 안보이게
                        obscureText: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: SizedBox(
                      //userphone입력
                      width: 350,
                      child: TextField(
                        controller: userPhoneController,
                        decoration: InputDecoration(
                          // hintText: 'ID를입력하세요',
                          labelText: '휴대전화',
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
                  ),
                  Padding(
                    //주소찾기 창
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: SizedBox(
                                  //userAddress입력창
                                  width: 250,
                                  child: TextField(
                                    controller: userAddressController,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      // hintText: 'ID를입력하세요',
                                      labelText: '주소',
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
                                          color: Color(0xFF727272),
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Color(0xFFFFBF1F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          //주소찾기 버튼
                          width: 100,
                          child: TextButton(
                            onPressed: () async {
                              KopoModel? model = await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => RemediKopo(),
                                ),
                              );
                              if (model != null) {
                                userAddressController.text = '${model.address}';
                                userDetail_AddressController.text =
                                    '${model.buildingName} / ';
                                setState(() {});
                              }
                              //${model.zonecode} /
                              // ${model.buildingName}
                              // => 13529 / 경기 성남시 분당구 판교역로 166 / 카카오 판교 아지트
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(100, 30),
                            ),
                            child: Text(
                              '주소 찾기',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFFFFBF1F),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: SizedBox(
                      //userAddress입력창
                      width: 350,
                      child: TextField(
                        controller: userDetail_AddressController,
                        decoration: InputDecoration(
                          // hintText: 'ID를입력하세요',
                          labelText: '상세주소',
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
                  ),
                  //성별 선택
                  SizedBox(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (userAddressController.text.isEmpty ||
                            userDetail_AddressController.text.isEmpty ||
                            userIDController.text.isEmpty ||
                            userPWController.text.isEmpty ||
                            userPhoneController.text.isEmpty
                            ) {
                          Get.snackbar(
                            "오류",
                            "정보 입력란을 확인 해주세요.",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                          );
                        } else {
                          insertUser();
                          Get.back();
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
                        '회원가입',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  reloadData(String email) async {
    handler.querySignUP(email);
    setState(() {});
  }

  insertUser() async {
    var userInsert = User(
      email: userIDController.text,
      password: userPWController.text,
      phone: userPhoneController.text,
      address: userAddressController.text + userDetail_AddressController.text,
      signupdate: DateTime.now().toString(),
      sex: dropDownValue,
    );

    await handler.insertUser(userInsert);
  }
}
