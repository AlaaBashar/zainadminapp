import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                      Text('الاسم الاول : ${model.firstName}',),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('الاسم الثاني : ${model.secondName}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('الاسم الثالث : ${model.thirdName}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('تاريخ الميلاد : ${model.dateOfBirth}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('الجنسية : ${model.nationality}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('الاستخدام الداخلي : ${model.internalUsage}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('السعر لكل شهر : ${model.pricePerMonth}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('مدة الالتزام : ${model.commitmentDuration}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('نهاية الزيارة : ${model.endVisit}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('نوع ID : ${model.idType}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('تاريخ الزيارة : ${DateFormat('yyyy/MM/hh  hh:mm a').format(model.date!)}'),
                      const SizedBox(
                        height: 6.0,
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
                      Text('اسم الموظف : ${model.user!.name}'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text('البريد الالكتروني : ${model.user!.email}'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text('الجنس : ${model.user!.gender}'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text('الرقم الوطني : ${model.user!.id}'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text('الحظر : ${model.user!.isBlocked}'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text('الاسم : ${model.user!.name}'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text('الهاتف : ${model.user!.phone}'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text('رقم الحساب الخاص : ${model.user!.uid}'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text('تاريخ تسجيل الحساب : ${DateFormat('yyyy/MM/hh  hh:mm a').format(model.user!.date!)}'),
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
