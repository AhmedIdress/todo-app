import 'package:localstorage/costants.dart';

class UserModel {
  late String name, email, phone;
  late int id;
  UserModel(
      {
        required this.id,
        required this.email,
        required this.name,
        required this.phone,});

  UserModel.fromJson(Map<String,dynamic> user){
    id=user[userId];
    name=user[userName];
    phone=user[userPhone];
    email=user[userEmail];
  }
  Map<String,dynamic> toJson(){
    return{
    userId:id,
    userName:name,
    userPhone:phone,
    userEmail:email};
  }
}
