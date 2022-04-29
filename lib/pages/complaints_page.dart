import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../dialog/yes_or_no_dialog.dart';
import '../models/complaint_model.dart';
import '../network/api.dart';
import '../utils.dart';
import '../widget/reusable_cached_network_image.dart';
import 'full_image_page.dart';


class ComplaintsPage extends StatefulWidget {
  const ComplaintsPage({Key? key}) : super(key: key);

  @override
  _ComplaintsPAgeState createState() => _ComplaintsPAgeState();
}

class _ComplaintsPAgeState extends State<ComplaintsPage> {
  List<ComplaintModel>? complaintList;

  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadComplaint();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الشكاوي'),
      ),
      body: complaintList != null
          ? IndexedStack(
              index: currentIndex,
              children: [
                complainsWidget(
                    ComplaintStatus.Pending, 'لا يوجد مشاكل قيد الانتظار'),
                complainsWidget(
                    ComplaintStatus.InProgress, 'لا يوجد مشاكل قيد المعالجة'),
                complainsWidget(
                    ComplaintStatus.Completed, 'لا يوجد مشاكل معالجة من قبل'),
                complainsWidget(
                    ComplaintStatus.Canceled, 'لا يوجد مشاكل ملغية'),
              ],
            )
          : getCenterCircularProgress(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: Colors.blueAccent,
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
              FontAwesomeIcons.edit,
            ),
            label: 'قيد الانتظار',
          ),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.edit), label: 'قيد المعالجة'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.edit), label: 'تمة معالجته'),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.edit), label: 'ملغي'),
        ],
      ),
    );
  }

  void loadComplaint() async {
    complaintList = await Api.getComplaints();
    setState(() {});
  }

  Widget complainsWidget(ComplaintStatus status, String titleEmpty) {
    int index = complaintList!
        .indexWhere((element) => element.complaintStatus == status);

    if (index == -1) {
      return Center(
        child: Text(
          titleEmpty,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
        ),
      );
    }

    return ListView.builder(
      itemCount: complaintList!.length,
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (_, index) {
        ComplaintModel model = complaintList![index];

        if (model.complaintStatus != status) return const SizedBox();

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
                        " الشكوى ",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  Text('عنوان الشكوى : ${model.title}'),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text('تفاصيل الشكوى : ${model.des}'),
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
                        " تفاصيل الوزارة ",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.account_balance_sharp,
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      Text('اسم الوزارة : ${model.ministriesTitle}')
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(child: Divider()),
                      Text(
                        " تفاصيل مقدم الشكوى ",
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
                  Text('الرقم الوطني : ${model.userId}'),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text('الاسم : ${model.username}'),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text('رقم الموبايل : ${model.userPhoneNumber}'),

                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: const <Widget>[
                      Expanded(child: Divider()),
                      Text(
                        " حالة الشكوى ",
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
                          Radio<ComplaintStatus>(
                            value: ComplaintStatus.Pending,
                            groupValue: model.complaintStatus,
                            activeColor: Colors.blueAccent,
                            onChanged: (ComplaintStatus? status) async {
                              await onChangedStatus(model, status,
                                  'هل انت متأكد من تغير حالة الشكوى لقيد الانتظار ؟');
                            },
                          ),
                          const Text('قيد الانتظار')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<ComplaintStatus>(
                            value: ComplaintStatus.InProgress,
                            groupValue: model.complaintStatus,
                            activeColor: Colors.blueAccent,
                            onChanged: (ComplaintStatus? status) async{
                              await onChangedStatus(model, status,
                                  'هل انت متأكد من تغير حالة الشكوى لقيد المعالجة ؟');

                            },
                          ),
                          const Text('قيد المعالجة'),
                        ],
                      ),
                      Row(
                        children: [
                          Radio<ComplaintStatus>(
                            value: ComplaintStatus.Completed,
                            groupValue: model.complaintStatus,
                            activeColor: Colors.blueAccent,
                            onChanged: (ComplaintStatus? status) async{
                              await onChangedStatus(model, status,
                                  'هل انت متأكد من تغير حالة الشكوى لتمة المعالجة ؟');

                            },
                          ),
                          const Text('تمة المعالجة')
                        ],
                      ),
                      Row(
                        children: [
                          Radio<ComplaintStatus>(
                            value: ComplaintStatus.Canceled,
                            groupValue: model.complaintStatus,
                            activeColor: Colors.blueAccent,
                        onChanged: (ComplaintStatus? status) async{
                          await onChangedStatus(model, status,
                              'هل انت متأكد من تغير حالة الشكوى لملغية ؟');
                        },

                          ),
                          const Text('ملغي'),
                        ],
                      ),
                    ],
                  ) ,

                  const Divider(),
                  InkWell(
                    onTap: (){
                      openNewPage(context, FullImagePage(imageUrl: model.imageUrl!));
                    },
                    child: ReusableCachedNetworkImage(
                      imageUrl: model.imageUrl!,
                      width: double.infinity,
                      height: 100,
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future onChangedStatus(
      ComplaintModel model, ComplaintStatus? status, String content) async {
    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialogYesORNo(
            onYes: () async {
              setState(() {
                model.complaintStatus = status;
              });
              ProgressCircleDialog.show(context);
              await Api.updateComplaint(model);
              ProgressCircleDialog.dismiss(context);

              Navigator.pop(context);
            },
            title: 'تغير حالة الشكوى',
            content: '$content\n\n ملاحظة: سوف يصل اشعار لمقدم الشكوى في حالة تغير الحالة');
      },
    );
  }
}
