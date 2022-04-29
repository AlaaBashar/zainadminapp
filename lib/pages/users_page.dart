import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dialog/yes_or_no_dialog.dart';
import '../models/user_model.dart';
import '../network/api.dart';
import '../utils.dart';


class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserApp> usersList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المستخدمين'),
      ),
      body: usersList.isNotEmpty
          ? RefreshIndicator(
              onRefresh: loadUsers,
              child: ListView.builder(
                itemCount: usersList.length,
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (_, index) {
                  UserApp userApp = usersList[index];
                  return Card(
                    color: Colors.white,
                    elevation: 8.0,
                    margin: const EdgeInsets.only(
                        left: 4.0, right: 4.0, top: 4.0, bottom: 0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'الاسم : ${userApp.name}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'الرقم الوطني : ${userApp.id}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'البريد الالكتروني : ${userApp.email}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'رقم الموبايل : ${userApp.phone}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'الجنس : ${userApp.gender == Gender.Male ? 'ذكر' : 'انثى'}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'تاريخ التسجيل : ${DateFormat('yyyy/MM/dd  hh:mm aa').format(userApp.date!)}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => onBlock(userApp, index),
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                                color: userApp.isBlocked!
                                    ? Colors.red[600]
                                    : Colors.green[600]),
                            child: Text(
                              userApp.isBlocked! ? 'محظور' : 'فعال',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          : getCenterCircularProgress(),
    );
  }

  Future loadUsers() async {
    usersList = await Api.getUsers();
    setState(() {});
  }

  void onBlock(UserApp userApp, int index) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialogYesORNo(
            title: !userApp.isBlocked! ? 'حظر مستخدم' : 'الغاء الحظر',
            content:
                'هل انت متأكد من ${userApp.isBlocked! ? 'الغاء ' : ''}حظر ${userApp.name}',
            onYes: () async {
              ProgressCircleDialog.show(context);

              await Api.updateUser(userApp);

              ProgressCircleDialog.dismiss(context);

              userApp.isBlocked = !userApp.isBlocked!;

              usersList[index] = userApp;

              setState(() {});
              Navigator.pop(context);
            },
          );
        });
  }
}
