import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zainadminapp/pages/suggestions_page.dart';
import '../network/auth.dart';
import '../utils.dart';
import 'areas_page.dart';
import 'contracts_page.dart';
import 'my_visits_page.dart';
import 'offers_page.dart';
import 'splash_page.dart';
import 'users_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        actions: [
          IconButton(
            onPressed: onLogout,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: GridView.count(

        crossAxisCount: 2,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
        children: [
          CardSection(
            title: 'العقود',
            onTap: () {
              openNewPage(context, const ContractPage());
            },
            icon: const Icon(
              CupertinoIcons.equal_square,
              size: 32.0,
            ),
          ),
          CardSection(
            title: 'العروض',
            onTap: () {
              openNewPage(context, const OffersPage());
            },
            icon: const Icon(
              CupertinoIcons.circle_grid_3x3,
              size: 32.0,
            ),
          ),
          CardSection(
            title: 'الزيارات',
            onTap: () {
              openNewPage(context, const MyVisitPage());
            },
            icon: const Icon(
              Icons.location_history_rounded,
              size: 32.0,
            ),
          ),
          CardSection(
            title: 'الاقتراحات',
            onTap: () {
              openNewPage(context, SuggestionsPage());
            },
            icon: const Icon(
              CupertinoIcons.book,
              size: 32.0,
            ),
          ),
          CardSection(
            title: 'المناطق',
            onTap: () {
              openNewPage(context, const AreasPage());
            },
            icon: const Icon(
              CupertinoIcons.location,
              size: 32.0,
            ),
          ),
          CardSection(
            title: 'المستخدمين',
            onTap: () {
              openNewPage(context, const UsersPage());
            },
            icon: const Icon(
              CupertinoIcons.person,
              size: 32.0,
            ),
          ),
        ],
      ),
    );
  }

  void onLogout() async {
    ProgressCircleDialog.show(context);
    await Auth.logout();
    ProgressCircleDialog.dismiss(context);
    openNewPage(context, const SplashPage(), popPreviousPages: true);
  }
}

class CardSection extends StatelessWidget {
  final Icon icon;
  final Function onTap;
  final String title;
  const CardSection(
      {Key? key, required this.icon, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      borderRadius: BorderRadius.circular(8.0),
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 16.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(
              height: 16,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
