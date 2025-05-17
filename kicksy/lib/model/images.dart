import 'dart:typed_data';

class Images {
  final int? code;
  final String modelname;
  final int num;
  final Uint8List image;

  Images({
    this.code,
    required this.modelname,
    required this.num,
    required this.image,
  });

  Images.fromMap(Map<String, dynamic> res)
    : code = res['img_code'],
      modelname = res['model_name'],
      num = res['img_num'],
      image = res['image'];
}
