import 'data.dart';

class User_ {
  int id;
  String? uid;
  String? token;
  UserType userType;
  String name;
  String password;
  String email;

  User_({
    required this.id, 
    required this.userType, 
    required this.name, 
    required this.password,
    required this.email,
    this.uid,
    this.token, 
  });

  @override
  String toString() {
    return 'User(id: $id, token: $token, userType: $userType, name: $name, password: $password, email: $email)';
  }
}