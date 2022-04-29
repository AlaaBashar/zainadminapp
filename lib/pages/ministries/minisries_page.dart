import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'add_ministries_page.dart';
import 'edit_ministries_page.dart';

class MinistriesPage extends StatefulWidget {
  const MinistriesPage({Key? key}) : super(key: key);

  @override
  _MinistriesPageState createState() => _MinistriesPageState();
}

class _MinistriesPageState extends State<MinistriesPage> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الوزارات'),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: const [
          AddMinistriesPage(),
          EditMinistriesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.folderPlus,
              ),
              label: 'اضافة'),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.edit,
              ),
              label: 'تعديل'),
        ],
      ),
    );
  }
}
