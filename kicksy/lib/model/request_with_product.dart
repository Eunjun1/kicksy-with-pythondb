import 'package:kicksy/model/product.dart';
import 'package:kicksy/model/request.dart';

class RequestWithProductWithModel{
  final Request request;
  final Product product;
  

  RequestWithProductWithModel({
    required this.request,
    required this.product,
    
  });

  factory RequestWithProductWithModel.fromMap(Map<String, dynamic> res) {
    return RequestWithProductWithModel(
      request: Request.fromMap(res),
      product: Product.fromMap(res),
    );
  }
}