import 'package:kicksy/model/model.dart';

import 'package:kicksy/model/product.dart';

class ProductWithModel {
  final Product product;
  final Model model;

  ProductWithModel({required this.product, required this.model});

  factory ProductWithModel.fromMap(Map<String, dynamic> res) {
    return ProductWithModel(
      product: Product.fromMap(res),
      model: Model.fromMap(res),
    );
  }
}
