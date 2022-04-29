import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/contract_model.dart';
import '../network/api.dart';
import '../utils.dart';


class ContractPage extends StatefulWidget {
  const ContractPage({Key? key}) : super(key: key);

  @override
  _ContractPageState createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  List<ContractModel>? contractsList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyContracts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('العقود'),
      ),
      body: contractsList != null
          ? ListView.builder(
          itemCount: contractsList!.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (_, index) {
            ContractModel model = contractsList![index];
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
                            " معلومات العقد  ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      Text('اسم العميل : ${model.customerName}',),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('رقم العميل : ${model.customerNumber}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('رقم البناء : ${model.buildCode}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('العرض : ${model.offer}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('مدة الالتزام : ${model.commitmentDuration}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('السرعة : ${model.speed}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('توقيع العميل : ${model.customerSignature}'),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text('تاريخ العقد : ${DateFormat('yyyy/MM/hh  hh:mm a').format(model.date!)}'),
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

  void loadMyContracts() async {
    contractsList = await Api.getContracts();
    setState(() {});
  }




}