import 'package:flutter/material.dart';

import '../models/complaint_model.dart';
import '../models/visits_model.dart';
import '../network/api.dart';
import '../utils.dart';

class MyVisitPage extends StatefulWidget {
  const MyVisitPage({Key? key}) : super(key: key);

  @override
  _MyVisitPageState createState() => _MyVisitPageState();
}

class _MyVisitPageState extends State<MyVisitPage> {
  List<VisitsModel>? visitsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyVisits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الزيارات'),
      ),
      body: visitsList != null
          ? ListView.builder(
          itemCount: visitsList!.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (_, index) {
            VisitsModel model = visitsList![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Row(
                        children: const <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            " الزيارة ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      visitText(labels:'الاسم الاول' ,text: model.firstName),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'الاسم الثاني' ,text: model.secondName),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'الاسم الثالث' ,text: model.thirdName),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'تاريخ الميلاد' ,text: model.dateOfBirth),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'الجنسية' ,text: model.nationality),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'نوع ID' ,text: model.idType),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'الاستخدام الداخلي' ,text: model.internalUsage),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'تاريخ الزيارة' ,text:dataFormat(date: model.date!)),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'السعر لكل شهر' ,text: model.pricePerMonth),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'مدة الالتزام' ,text: model.commitmentDuration),
                      const SizedBox(
                        height: 5.0,
                      ),
                      visitText(labels:'نهاية الزيارة' ,text: model.endVisit),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        children: const <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            "  معلومات المستخدم  ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      visitText(labels:'اسم الموظف' ,text: model.user!.name),
                      const SizedBox(
                        height: 8.0,
                      ),
                      visitText(labels:'البريد الالكتروني' ,text: model.user!.email),
                      const SizedBox(
                        height: 8.0,
                      ),
                      visitText(labels:'الجنس' ,text: model.user!.gender),
                      const SizedBox(
                        height: 8.0,
                      ),
                      visitText(labels:'الرقم الوطني' ,text: model.user!.id),
                      const SizedBox(
                        height: 8.0,
                      ),
                      visitText(labels:'الحظر' ,text: model.user!.isBlocked),
                      const SizedBox(
                        height: 8.0,
                      ),
                      visitText(labels:'الاسم' ,text: model.user!.name),
                      const SizedBox(
                        height: 8.0,
                      ),
                      visitText(labels:'الهاتف' ,text: model.user!.phone),
                      const SizedBox(
                        height: 8.0,
                      ),
                      visitText(labels:'تاريخ تسجيل الحساب' ,text:dataFormat(date: model.user!.date!)),
                      const SizedBox(
                        height: 8.0,
                      ),
                    ],
                  ),
                ),
              ),
            );
          })
          : getCenterCircularProgress(),
    );
  }
  Widget visitText({dynamic text, String? labels}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '$labels : ',
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),

        ),
        Text(
          '$text',
        ),

      ],
    );
  }
  void loadMyVisits() async {
    visitsList = await Api.getVisits();
    setState(() {});
  }

  Widget getStatus(ComplaintModel model) {

    if(model.complaintStatus == ComplaintStatus.Pending){
      return const Text('قيد الانتظار' ,
        style: TextStyle(
          color:  Colors.yellow,
          fontWeight: FontWeight.bold,
        ),);
    }

    else if(model.complaintStatus == ComplaintStatus.InProgress){
      return const Text('قيد المعالجة',
        style: TextStyle(
          color:  Colors.blue,
          fontWeight: FontWeight.bold,
        ),);
    }

    else if(model.complaintStatus == ComplaintStatus.Completed){
      return const Text('تمة المعالجة',
        style: TextStyle(
          color:  Colors.green,
          fontWeight: FontWeight.bold,
        ),);
    }

    else if(model.complaintStatus == ComplaintStatus.Canceled){
      return  const Text('ملغي',
        style: TextStyle(
          color:  Colors.red,
          fontWeight: FontWeight.bold,
        ),);
    }

    return const SizedBox() ;
  }


}
