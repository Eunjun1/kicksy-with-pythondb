import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kicksy/vm/database_handler.dart';
import 'package:http/http.dart' as http;

class HqInsert extends StatefulWidget {
  const HqInsert({super.key});

  @override
  State<HqInsert> createState() => _HqInsertState();
}

class _HqInsertState extends State<HqInsert> {
  late DatabaseHandler handler;
  final ImagePicker picker = ImagePicker();
  late TextEditingController nameCT;
  late TextEditingController companyCT;
  late TextEditingController categoryCT;
  late TextEditingController colorCT;
  late TextEditingController salepriceCT;
  late TextEditingController maxstockCT;
  late TextEditingController maxSizeCT;
  late TextEditingController minSizeCT;

  late bool createModel;

  XFile? imageFile;
  late List<dynamic> images;
  late int modelNum;
  List modelList = [];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    nameCT = TextEditingController();
    companyCT = TextEditingController();
    categoryCT = TextEditingController();
    colorCT = TextEditingController();
    salepriceCT = TextEditingController();
    maxstockCT = TextEditingController();
    maxSizeCT = TextEditingController();
    minSizeCT = TextEditingController();
    images = [];

    createModel = false;
    modelNum = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 40),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      getImageFromGallery(ImageSource.gallery);
                      setState(() {});
                    },
                    icon: Icon(Icons.add),
                  ),
                  images.isNotEmpty
                      ? SizedBox(
                        height: 100,
                        width: 350,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.memory(images[index]),
                            );
                          },
                        ),
                      )
                      : Text('이미지를 선택해주세요'),
                ],
              ),
              TextField(
                controller: nameCT,
                decoration: InputDecoration(labelText: '모델 이름 :'),
              ),
              TextField(
                controller: companyCT,
                decoration: InputDecoration(labelText: '제조사 :'),
              ),
              TextField(
                controller: categoryCT,
                decoration: InputDecoration(labelText: '카테 고리 :'),
              ),
              TextField(
                controller: colorCT,
                decoration: InputDecoration(labelText: '색상 :'),
              ),
              TextField(
                controller: salepriceCT,
                decoration: InputDecoration(labelText: '판매 가격 :'),
              ),
              TextField(
                controller: maxSizeCT,
                decoration: InputDecoration(labelText: '최대 사이즈 :'),
              ),
              TextField(
                controller: minSizeCT,
                decoration: InputDecoration(labelText: '최소 사이즈 :'),
              ),
              TextField(
                controller: maxstockCT,
                decoration: InputDecoration(labelText: '최대 재고량 :'),
              ),

              ElevatedButton(
                onPressed: () async {
                  await insertImageAndModel();
                  await insertProduct();
                  Get.back();
                },

                child: Text('등록'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImageFromGallery(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile == null) {
      return;
    } else {
      imageFile = XFile(pickedFile.path);
      File imageFile1 = File(imageFile!.path);
      Uint8List getImage = await imageFile1.readAsBytes();
      images.add(getImage);
      setState(() {});
    }
  }

  insertImageAndModel() async {
    // 2. 이미지가 저장되었을 경우에만 모델 저장
    var request = http.MultipartRequest(
      "POST",
      Uri.parse('http://127.0.0.1:8000/model/insert'),
    );
    request.fields['image_num'] = 0.toString();
    request.fields['name'] = nameCT.text;
    request.fields['category'] = categoryCT.text;
    request.fields['company'] = companyCT.text;
    request.fields['color'] = colorCT.text;
    request.fields['saleprice'] = salepriceCT.text;

    var res = await request.send();
    if (res.statusCode == 200) {
      Get.snackbar('완', '완');
    } else {
      Get.snackbar('X', 'X');
    }
    setState(() {});
    // 1. 이미지 먼저 저장
    for (int i = 0; i < images.length; i++) {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('http://127.0.0.1:8000/image/insert'),
      );
      request.fields['model_name'] = nameCT.text;
      request.fields['img_num'] = i.toString();

      if (imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromBytes('file', images[i]),
        );
      }
      var res = await request.send();
      if (res.statusCode == 200) {
      } else {}
    }
  }

  insertProduct() async {
    for (
      int i = int.parse(minSizeCT.text);
      i < int.parse(maxSizeCT.text);
      i += 10
    ) {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse('http://127.0.0.1:8000/product/insert'),
      );
      request.fields['model_code'] = (modelList.length + 1).toString();
      request.fields['size'] = i.toString();
      request.fields['maxstock'] = maxstockCT.text;
      request.fields['registration'] = DateTime.now().toString();
      var res = await request.send();

      if (res.statusCode == 200) {
        Get.snackbar('완', '완');
      } else {
        Get.snackbar('X', 'X');
      }
      setState(() {});
    }
  }

  //'product(model_code integer, size integer, maxstock integer',
  //'image(img_code integer primary key autoincrement, model_name text ,img_num integer, image blob, foreign key (model_name) references model(mod_name))',
  //'model(mod_code integer primary key autoincrement, image_num integer ,name text, category text, company text, color text, saleprice integer, foreign key (image_num) references image(img_num))',
}
