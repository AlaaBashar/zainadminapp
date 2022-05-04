import 'package:flutter/material.dart';

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
                      contractsText(labels:'اسم العميل' ,text: model.customerName),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'رقم العميل' ,text: model.customerNumber),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'رقم البناء' ,text: model.buildCode),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'العرض' ,text: model.offer),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'مدة الالتزام' ,text: model.commitmentDuration),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'السرعة' ,text: model.speed),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'توقيع العميل' ,text: model.customerSignature),
                      const SizedBox(
                        height: 5.0,
                      ),
                      contractsText(labels:'تاريخ العقد' ,text:dataFormat(date: model.date!)),

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
                      contractsText(labels:'اسم الموظف' ,text: model.user!.name),

                      const SizedBox(
                        height: 8.0,
                      ),
                      contractsText(labels:'البريد الالكتروني' ,text: model.user!.email),

                      const SizedBox(
                        height: 8.0,
                      ),
                      contractsText(labels:'الجنس' ,text: model.user!.gender),
                      const SizedBox(
                        height: 8.0,
                      ),
                      contractsText(labels:'الرقم الوطني' ,text: model.user!.id),
                      const SizedBox(
                        height: 8.0,
                      ),
                      contractsText(labels:'الحظر' ,text: model.user!.isBlocked),
                      const SizedBox(
                        height: 8.0,
                      ),
                      contractsText(labels:'الاسم' ,text: model.user!.name),
                      const SizedBox(
                        height: 8.0,
                      ),
                      contractsText(labels:'الهاتف' ,text: model.user!.phone),
                      const SizedBox(
                        height: 8.0,
                      ),
                      contractsText(labels:'تاريخ تسجيل الحساب' ,text:dataFormat(date: model.user!.date!)),
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

  Widget contractsText({dynamic text, String? labels}) {
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
  void loadMyContracts() async {
    contractsList = await Api.getContracts();
    setState(() {});
  }




}