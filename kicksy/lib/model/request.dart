class Request {
  final int? num;
  final String userId;
  final int productCode;
  final int storeCode;
  final int type;
  final String date; 
  final int count;
  final String? reason;

  Request({
    this.num,
    required this.userId,
    required this.productCode,
    required this.storeCode,
    required this.type,
    required this.date,
    required this.count,
    this.reason
  });
  
  Request.fromMap(Map<String, dynamic> res)
  : num = res['req_num'],
  userId = res['user_email'],
  productCode = res['product_code'],
  storeCode = res['store_code'],
  type = res['req_type'],
  date = res['req_date'],
  count = res['req_count'],
  reason = res['reason'];
}