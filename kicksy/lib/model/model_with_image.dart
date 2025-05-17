import 'package:kicksy/model/images.dart';
import 'package:kicksy/model/model.dart';

class ModelWithImage {
  final Model model;
  final Images images;

  ModelWithImage({required this.model, required this.images});

  // fromMap을 통해 Map을 결합하여 하나의 객체로 반환
  factory ModelWithImage.fromMap(Map<String, dynamic> res) {
    return ModelWithImage(
      model: Model.fromMap(res),
      images: Images.fromMap(res),
    );
  }
}
