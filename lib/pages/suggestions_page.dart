import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../dialog/yes_or_no_dialog.dart';
import '../models/suggestions_model.dart';
import '../network/api.dart';
import '../utils.dart';


class SuggestionsPage extends StatefulWidget {
  const SuggestionsPage({Key? key}) : super(key: key);

  @override
  _SuggestionsPageState createState() => _SuggestionsPageState();
}

class _SuggestionsPageState extends State<SuggestionsPage> {
  List<SuggestionModel>? suggestionList;

  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSuggestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاقتراحات'),
      ),
      body: suggestionList != null
          ? IndexedStack(
        index: currentIndex,
        children: [
          suggestionWidget(
              SuggestionStatus.Pending, 'لا يوجد اقتراحات قيد الانتظار'),
          suggestionWidget(
              SuggestionStatus.Approve, 'لا يوجد اقتراحات مقبولة'),
          suggestionWidget(
              SuggestionStatus.Rejected, 'لا يوجد اقتراحات مرفوضه'),
        ],
      )
          : getCenterCircularProgress(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedLabelStyle: const TextStyle(color: Colors.black),
        selectedItemColor: Colors.blueAccent,
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        elevation: 8,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.bookReader,
            ),
            label: 'قيد الانتظار',
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bookReader), label: 'مقبولة'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bookReader), label: 'مرفوض'),

        ],
      ),
    );
  }

  void loadSuggestion() async {
    suggestionList = await Api.getSuggestions();
    setState(() {});
  }

  Widget suggestionWidget(SuggestionStatus status, String titleEmpty) {
    int index = suggestionList!
        .indexWhere((element) => element.suggestionsStatus == status);

    if (index == -1) {
      return Center(
        child: Text(
          titleEmpty,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
        ),
      );
    }

    return ListView.builder(
      itemCount: suggestionList!.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (_, index) {
        SuggestionModel model = suggestionList![index];

        if (model.suggestionsStatus != status) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const <Widget>[
                      Expanded(child: Divider()),
                      Text(
                        " الاقتراح ",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  Text('عنوان الاقتراح : ${model.title}'),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text('تفاصيل الاقتراح : ${model.des}'),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text('التاريخ : ${DateFormat('yyyy/MM/hh  hh:mm a').format(model.date!)}'),
                  const SizedBox(
                    height: 5.0,
                  ),

                  Row(
                    children: const <Widget>[
                      Expanded(child: Divider()),
                      Text(
                        " تفاصيل مقدم الاقتراح ",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text('الرقم الوطني : ${model.user!.id}'),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text('الاسم : ${model.user!.name}'),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text('رقم الموبايل : ${model.user!.phone}'),

                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(child: Divider()),
                      Text(
                        " حالة الاقتراح ",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 6),
                    children: [
                      Row(
                        children: [
                          Radio<SuggestionStatus>(
                            value: SuggestionStatus.Pending,
                            groupValue: model.suggestionsStatus,
                            activeColor: Colors.blueAccent,
                            onChanged: (SuggestionStatus? status) async {
                              await onChangedStatus(model, status,
                                  'هل انت متأكد من تغير حالة الاقتراح لقيد الانتظار ؟');
                            },
                          ),
                          const Text('قيد الانتظار')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<SuggestionStatus>(
                            value: SuggestionStatus.Approve,
                            groupValue: model.suggestionsStatus,
                            activeColor: Colors.blueAccent,
                            onChanged: (SuggestionStatus? status) async{
                              await onChangedStatus(model, status,
                                  'هل انت متأكد من تغير حالة الاقتراح لمقبول ؟');

                            },
                          ),
                          const Text('مقبول'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<SuggestionStatus>(
                            value: SuggestionStatus.Rejected,
                            groupValue: model.suggestionsStatus,
                            activeColor: Colors.blueAccent,
                            onChanged: (SuggestionStatus? status) async{
                              await onChangedStatus(model, status,
                                  'هل انت متأكد من تغير حالة الاقتراح لمرفوض ؟');
                            },

                          ),
                          const Text('مرفوض'),
                        ],
                      ),
                    ],
                  ) ,


                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future onChangedStatus(
      SuggestionModel model, SuggestionStatus? status, String content) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialogYesORNo(
            onYes: () async {
              setState(() {
                model.suggestionsStatus = status;
              });
              ProgressCircleDialog.show(context);
              await Api.updateSuggestion(model);
              ProgressCircleDialog.dismiss(context);

              Navigator.pop(context);
            },
            title: 'تغير حالة الاقتراح',
            content: '$content\n\n ملاحظة: سوف يصل اشعار لمقدم الاقتراح في حالة تغير الحالة');
      },
    );
  }

}
