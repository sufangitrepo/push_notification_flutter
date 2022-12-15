

class UserModel{
  String? email;
  String? id;
  String? token;

  UserModel({required this.email, required this.id});

  UserModel.fromMap(Map<String,dynamic> map){
    email = map["email"];
    id = map["id"];
    token = map["notification_token"];
  }

  @override
  String toString() {
    return 'UserModel{email: $email, id: $id, token: $token}';
  }
}