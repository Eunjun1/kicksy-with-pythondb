import 'package:kicksy/model/document.dart';
import 'package:kicksy/model/orderying.dart';

class OrderyingWithDocument {
  final Orderying orderying;
  final Document document;

  OrderyingWithDocument({
    required this.orderying,
    required this.document,
  });

  // fromMap을 통해 Map을 결합하여 하나의 객체로 반환
  factory OrderyingWithDocument.fromMap(Map<String, dynamic> res) {
    return OrderyingWithDocument(
      orderying: Orderying.fromMap(res),  // Orderying 데이터
      document: Document.fromMap(res),    // Document 데이터
    );
  }
}
