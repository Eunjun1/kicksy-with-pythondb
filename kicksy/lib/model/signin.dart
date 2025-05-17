import 'package:kicksy/model/employee.dart';
import 'package:kicksy/model/user.dart';

class Signin {
  final User user;
  final Employee employee;

  Signin({required this.user, required this.employee});

  factory Signin.fromMap(Map<String, dynamic> res) {
    return Signin(user: User.fromMap(res), employee: Employee.fromMap(res));
  }
}
