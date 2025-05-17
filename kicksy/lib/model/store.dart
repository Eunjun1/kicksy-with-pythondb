class Store {
  final int strCode;
  final String name;
  final String tel;
  final String address;

  Store({
    required this.strCode,
    required this.name,
    required this.tel,
    required this.address
  });

  Store.fromMap(Map<String, dynamic> res)
    : strCode = res['str_code'],
      name = res['name'],
      tel = res['tel'],
      address = res['address'];
}
