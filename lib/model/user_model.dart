import 'package:localstorage/costants.dart';

class UserModel {
  late String name, email, phone;

  UserModel(
      {required this.email,
      required this.name,
      required this.phone});

  UserModel.fromJson(Map<String,dynamic> user){
    name=user[userName];
    phone=user[userPhone];
    email=user[userEmail];
  }
  Map<String,dynamic> toJson(){
    return{
    userName:name,
    userPhone:phone,
    userEmail:email};
  }
}
