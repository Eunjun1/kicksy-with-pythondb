class User {
  final String email;
  final String password;
  final String phone;
  final String address;
  final String signupdate;
  final String sex;

  User({
    required this.email,
    required this.password,
    required this.phone,
    required this.address,
    required this.signupdate,
    required this.sex,
  });

  User.fromMap(Map<String, dynamic> res)
    : email = res['email'],
      password = res['password'],
      phone = res['phone'],
      address = res['address'],
      signupdate = res['signupdate'],
      sex = res['sex'];
}
