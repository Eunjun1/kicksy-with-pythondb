class Model {
  final int? code;
  final String name;
  final int imageNum;
  final String category;
  final String company;
  final String color;
  final int saleprice;

  Model({
    this.code,
    required this.name,
    required this.imageNum,
    required this.category,
    required this.company,
    required this.color,
    required this.saleprice,
  });

  Model.fromMap(Map<String, dynamic> res)
    : code = res['mod_code'],
      name = res['name'] ?? '',
      imageNum = res['image_num'],
      category = res['category'],
      company = res['company'],
      color = res['color'],
      saleprice = res['saleprice'];
}
