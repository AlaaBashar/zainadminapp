import 'package:flutter/material.dart';


import '../helper/image_helper.dart';
import '../models/admin_model.dart';
import '../network/api.dart';
import '../network/auth.dart';
import '../utils.dart';
import 'home_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(
      const Duration(
        seconds: 2,
      ),
    ).then(
      (value) => checkLoginAdmin(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageHelper.LOGO_PNG,
            width: 150.0,
            height: 150.0,
          ),
          const SizedBox(
            height: 16.0,
          ),
          const Text(
            'Admins',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          const SizedBox(
            height: 16.0,
          ),
          getCenterCircularProgress(),
        ],
      ),
    );
  }

  void checkLoginAdmin() async {
    AdminApp? admin = await Auth.getUserFromPref();

    if (admin == null) {
      openNewPage(context, const LoginPage(), popPreviousPages: true);
      return;
    } else {
      AdminApp? userLogin = await Api.getAdminFromUid(admin.uid ?? '');
      if (userLogin == null) {
        await Auth.logout();
        openNewPage(context, const LoginPage(), popPreviousPages: true);
        return;
      }

      await Auth.updateUserInPref(userLogin);

      openNewPage(context, const HomePage(), popPreviousPages: true);
    }
  }
}
