import 'package:flutter/material.dart';
import 'package:localstorage/helper/database_helper.dart';
import 'package:localstorage/model/user_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late String name, phone, email;
  bool flag = false;
  int id=0;
  late int editId;
  /*List<UserModel>? list=[];*/

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Contacts'),
      ),
      body: _viewAllUsers(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        _viewAlertDialog(null);
      },
      backgroundColor: Colors.red,
      child: const Icon(Icons.add),
    );
  }

  _onEdit(UserModel model) {
    _viewAlertDialog(model);
  }

  _viewAlertDialog(UserModel? model) {
    if (model != null) {
      name = model.name;
      phone = model.phone;
      email = model.email;
      editId=model.id;
      flag=true;
    } else {
      name = '';
      phone = '';
      email = '';
      flag=false;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SizedBox(
              width: 300,
              child: Form(
                key: _key,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: name,
                      decoration: InputDecoration(
                        hintText: 'Add name',
                        fillColor: Colors.grey.shade300,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the name';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        name = value ?? '';
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      initialValue: phone,
                      decoration: InputDecoration(
                        hintText: 'Add phone',
                        fillColor: Colors.grey.shade300,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the phone';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        phone = value ?? '';
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      initialValue: email,
                      decoration: InputDecoration(
                        hintText: 'Add email',
                        fillColor: Colors.grey.shade300,
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the email';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        email = value ?? '';
                      },
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        _key.currentState?.save();
                        if(_key.currentState!.validate())
                          {
                        !flag
                            ? await DataBaseHelper.db
                                .insert(UserModel(id: id++,
                                    email: email, name: name, phone: phone))
                                .then((value) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('contact has been added')));
                                name = '';
                                phone = '';
                                email = '';
                                setState(() {});
                              })
                            : await DataBaseHelper.db
                                .update(UserModel(id:editId ,
                                    email: email, name: name, phone: phone))
                                .then((value) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('contact has been edited')));
                                name = '';
                                phone = '';
                                email = '';
                                flag=false;
                                setState(() {});
                              });}
                      },
                      child: Text(!flag?'Add user':'Edit user'),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _viewAllUsers() {
    return FutureBuilder(
        future: _getData(),
        builder: (context, snapshot) {
          List<UserModel>? list = snapshot.data as List<UserModel>?;

          return ListView.builder(
            itemCount: list?.length,
            itemBuilder: (context, index) => Dismissible(
              key: UniqueKey(),
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                children: const [
                  Icon(Icons.delete,color: Colors.white,),
                  Spacer(),
                  Icon(Icons.delete,color: Colors.white,),
                ],
              ),),
              onDismissed: (direction){
                DataBaseHelper.db.delete(index).then((value) {
                  /*_getData().then((value) {
                    list=value;
                  });*/
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('contact has been deleted')));
                });
              },
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.brown,
                    child: Text(
                      list![index].name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.account_circle),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              list[index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.phone),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                list[index].phone,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              list[index].email,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: IconButton(
                      onPressed: () => _onEdit(list[index]),
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Future<List<UserModel>?> _getData() async {
    return await DataBaseHelper.db.readAllUsers();
  }
}
