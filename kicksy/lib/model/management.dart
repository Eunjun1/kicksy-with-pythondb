class Management {
  final int? num;
  final int employeeCode;
  final int productCode;
  final int storeCode;
  final int type;
  final String date;
  final int count;

  Management({
    this.num,
    required this.employeeCode,
    required this.productCode,
    required this.storeCode,
    required this.type,
    required this.date,
    required this.count,
  });

  Management.fromMap(Map<String, dynamic> res)
    : num = res['mag_num'],
      employeeCode = res['employee_code'],
      productCode = res['product_code'],
      storeCode = res['store_code'],
      type = res['mag_type'],
      date = res['mag_date'],
      count = res['mag_count'];
}

// create table management(mag_num integer primary key autoincrement, employee_code integer, product_code integer, store_code integer ,mag_type integer, mag_date date, mag_count integer, foreign key (employee_code) references employee(emp_code), foreign key (product_code) references product(prod_code), foreign key (store_code) references store(str_code))',
