import 'package:kicksy/model/document.dart';
import 'package:kicksy/model/employee.dart';
import 'package:kicksy/model/orderying.dart';

class OrderyingWithDocumentWithEmployee {
  final Orderying orderying;
  final Document document;
  final Employee employee;

  OrderyingWithDocumentWithEmployee({
    required this.orderying,
    required this.document,
    required this.employee
  });

  // fromMap을 통해 Map을 결합하여 하나의 객체로 반환
  factory OrderyingWithDocumentWithEmployee.fromMap(Map<String, dynamic> res) {
    return OrderyingWithDocumentWithEmployee(
      orderying: Orderying.fromMap(res),
      document: Document.fromMap(res),
      employee: Employee.fromMap(res)
    );
  }
}