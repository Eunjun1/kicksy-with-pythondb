class Employee {
  final int emp_code;
  final String password;
  final String division;
  final String grade;

  Employee({
    required this.emp_code,
    required this.password,
    required this.division,
    required this.grade,
  });

  Employee.fromMap(Map<String, dynamic> res)
    : emp_code = res['emp_code'],
      password = res['password'],
      division = res['division'],
      grade = res['grade'];
}
