import 'package:kicksy/model/management.dart';
import 'package:kicksy/model/request.dart';
import 'package:kicksy/model/store.dart';

class ManagementWithRequestWithStore {
  final Management management;
  final Request request;
  final Store store;

  ManagementWithRequestWithStore({
    required this.management,
    required this.request,
    required this.store
  });

  factory ManagementWithRequestWithStore.fromMap(Map<String, dynamic> res) {
    return ManagementWithRequestWithStore(
      management: Management.fromMap(res),
      request: Request.fromMap(res),
      store: Store.fromMap(res),
    );
  }

}

