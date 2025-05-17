import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kicksy/model/images.dart';
import 'package:kicksy/model/model.dart';
import 'package:kicksy/model/product.dart';
import 'package:kicksy/vm/database_handler.dart';

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
    int lastImageNum = -1;

    // 1. 이미지 먼저 저장
    for (int i = 0; i < images.length; i++) {
      var imagesInsert = Images(
        num: i,
        modelname: nameCT.text,
        image: images[i],
      );

      lastImageNum = await handler.insertimage(imagesInsert); // 반환값을 저장
    }

    // 2. 이미지가 저장되었을 경우에만 모델 저장
    if (lastImageNum != -1) {
      var modelInsert = Model(
        name: nameCT.text,
        imageNum: 0,
        category: categoryCT.text,
        company: companyCT.text,
        color: colorCT.text,
        saleprice: int.parse(salepriceCT.text),
      );

      await handler.insertModel(modelInsert);
      createModel = true;
      setState(() {});
    }
  }

  insertProduct() async {
    await loadModelNum();

    for (
      int i = int.parse(minSizeCT.text);
      i <= int.parse(maxSizeCT.text);
      i += 10
    ) {
      var productInsert = Product(
        modelCode: modelNum,
        size: i,
        maxstock: int.parse(maxstockCT.text),
        registration: DateTime.now().toString(),
      );

      await handler.insertProduct(productInsert);
    }
  }

  Future<void> loadModelNum() async {
    modelNum = await handler.getModelNum();
    setState(() {});
  }

  //'product(model_code integer, size integer, maxstock integer',
  //'image(img_code integer primary key autoincrement, model_name text ,img_num integer, image blob, foreign key (model_name) references model(mod_name))',
  //'model(mod_code integer primary key autoincrement, image_num integer ,name text, category text, company text, color text, saleprice integer, foreign key (image_num) references image(img_num))',
}
