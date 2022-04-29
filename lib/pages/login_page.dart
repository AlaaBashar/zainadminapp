import 'package:flutter/material.dart';


import '../helper/image_helper.dart';
import '../models/admin_model.dart';
import '../network/auth.dart';
import '../utils.dart';
import '../widget/text_field_app.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showPassword = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> loginFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: loginFormKey,
            child: Column(
              children: [
                Hero(
                  tag: 'logo',
                  child: Image.asset(
                    ImageHelper.LOGO_PNG,
                    width: 150.0,
                    height: 150.0,
                  ),
                ),

                const SizedBox(
                  height: 32.0,
                ),
                const Text(
                  'Admin',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                TextFieldApp(
                  controller: emailController,
                  hintText: 'البريد الالكتروني',
                  icon: const Icon(Icons.email),
                  isRTL: false,
                  type: TextInputType.emailAddress,
                  validator: (str) => !isValidEmail(str!.trim())
                      ? 'البريد الالكتروني غير صحيح'
                      : null,
                ),
                TextFieldApp(
                  controller: passwordController,
                  hintText: 'الرمز السري',
                  icon: const Icon(Icons.vpn_key),
                  obscureText: !showPassword,
                  onActionComplete: onLogin,
                  isRTL: false,
                  validator: (str) =>
                  str!.isEmpty ? 'الرمز السري غير صحيح' : null,
                  type: TextInputType.visiblePassword,
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: showPassword
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility_outlined),
                  ),
                ),
                Container(
                  width: getScreenWidth(context),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextButton(
                    onPressed: onForgotPass,
                    child: const Text(
                      'هل نسيت كلمة السر ؟',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: getScreenWidth(context),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                  child: ElevatedButton(
                    onPressed: onLogin,
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void onLogin() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!loginFormKey.currentState!.validate()) return;

    ProgressCircleDialog.show(context);
    AdminApp? adminApp = await Auth.loginByEmailAndPass(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((onError) {
      showSnackBar(context, onError.toString());
      ProgressCircleDialog.dismiss(context);

    });
    ProgressCircleDialog.dismiss(context);

    if (adminApp == null) {
      await Auth.logout();
      return;
    }

    await Auth.updateUserInPref(adminApp);
    openNewPage(context, const HomePage(), popPreviousPages: true);
  }

  void onForgotPass() async {
    TextEditingController controller = TextEditingController();
    GlobalKey<FormState> forgotKey = GlobalKey();

    String? result = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Container(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 20.0,
                    ),
                    const Text(
                      'أعادة تعين كلمة سر',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              bottomLeft: Radius.circular(0),
                              topRight: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      child: const Text('إعادة تعين'),
                      onPressed: () async {
                        if (!forgotKey.currentState!.validate()) return;

                        String? email = controller.text;

                        FocusScope.of(context).requestFocus(FocusNode());

                        ProgressCircleDialog.show(context);
                        await Auth.forgotPassword(email).catchError((onError) {
                          ProgressCircleDialog.dismiss(context);

                          Navigator.pop(context, onError.toString());
                        });
                        ProgressCircleDialog.dismiss(context);
                      },
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    'سوف يصلك رابط على بريدك الالكتروني لتعين كلمة مرور جديدة ، الرجاء التأكد من ادخال البريد الالكتروني بشكل صحيح',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Form(
                  key: forgotKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: TextFieldApp(
                    controller: controller,
                    hintText: 'البريد الالكتروني',
                    icon: const Icon(Icons.email),
                    isRTL: false,
                    type: TextInputType.emailAddress,
                    validator: (str) => !isValidEmail(str!.trim())
                        ? 'البريد الالكتروني غير صحيح'
                        : null,
                  ),
                ),
                const SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result == null) return;
    showSnackBar(context, result);
  }


}
