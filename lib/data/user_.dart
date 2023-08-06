import 'data.dart';

class User_ {
  int id;
  String token;
  UserType userType;
  String name;
  String password;
  String email;

  User_({
    required this.id, 
    required this.token, 
    required this.userType, 
    required this.name, 
    required this.password,
    required this.email,
  });

  @override
  String toString() {
    return 'User(id: $id, token: $token, userType: $userType, name: $name, password: $password, email: $email)';
  }
}