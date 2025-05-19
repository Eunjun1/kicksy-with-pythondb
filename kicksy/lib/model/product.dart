class Product {
  final int? code;
  final int modelCode;
  final int size;
  final int maxstock;
  final String registration;

  Product({
    this.code,
    required this.modelCode,
    required this.size,
    required this.maxstock,
    required this.registration,
  });

  Product.fromMap(Map<String, dynamic> res)
    : code = res['prod_code'],
      modelCode = res['model_code'],
      size = res['size'],
      maxstock = res['maxstock'],
      registration = res['registration'];

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      code: json['code'], 
      modelCode: json['modelCode'], 
      size: json['size'], 
      maxstock: json['maxstock'],
      registration: json['registration'],
    ); 
  }

}
