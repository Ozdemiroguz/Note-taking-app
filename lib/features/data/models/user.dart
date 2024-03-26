class User {
  String userId;
  String name;
  String surname;
  String email;
  String password;
  String phone;

  User(
      {required this.userId,
      required this.name,
      required this.surname,
      required this.email,
      required this.password,
      required this.phone});

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'surname': surname,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }
}
