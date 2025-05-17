class Orderying {
  final int? num;
  final int employeeCode;
  final int productCode;
  final int documentCode;
  final int type;
  final String date;
  final int count;
  final String? rejectReason;

  Orderying({
    this.num,
    required this.employeeCode,
    required this.productCode,
    required this.documentCode,
    required this.type,
    required this.date,
    required this.count,
    this.rejectReason,
  });

  Orderying.fromMap(Map<String, dynamic> res)
    : num = res['ody_num'],
      employeeCode = res['employee_code'],
      productCode = res['product_code'],
      documentCode = res['document_code'],
      type = res['ody_type'],
      date = res['ody_date'],
      count = res['ody_count'],
      rejectReason = res['reject_reason'];
}
