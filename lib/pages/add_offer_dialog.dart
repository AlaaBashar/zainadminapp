import 'package:flutter/material.dart';

import '../models/offers_model.dart';
import '../network/api.dart';
import '../utils.dart';
import '../widget/text_field_app.dart';


class AddOfferDialog extends StatefulWidget {
  const AddOfferDialog({Key? key}) : super(key: key);

  @override
  _AddOfferDialogState createState() => _AddOfferDialogState();
}

class _AddOfferDialogState extends State<AddOfferDialog> {
  TextEditingController speedController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ارسال عرض جديد'),

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          )),
      content: Container(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [

                TextFieldApp(
                  controller: speedController,
                  hintText: 'السرعة',
                  icon: const Icon(Icons.title),
                  validator: (str)=> str!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  margin: const EdgeInsets.symmetric(horizontal: 0 , vertical: 16.0),
                ),

                TextFieldApp(
                  controller: priceController,
                  hintText: 'السعر',
                  icon: const Icon(Icons.monetization_on),
                  type: TextInputType.number,

                  margin: const EdgeInsets.symmetric(horizontal: 0 , vertical: 16.0),

                  validator: (str)=> str!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),

                TextFieldApp(
                  controller: discountController,
                  hintText: 'الخصم',
                  icon: const Icon(Icons.local_offer),
                  type: TextInputType.number,

                  margin: const EdgeInsets.symmetric(horizontal: 0 , vertical: 16.0),

                  validator: (str)=> str!.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),

                const SizedBox(height: 16.0,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onOffers,
                    child: const Text('اضافة اقتراح'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onOffers() async{

    if(!formKey.currentState!.validate()) {
      return;
    }

    String? speed = speedController.text ;
    String? price = priceController.text ;
    String? discount = discountController.text ;


    ProgressCircleDialog.show(context);

    OffersModel offersModel = OffersModel();

    offersModel
      ..speed = speed
      ..price = price
      ..discount=discount;


    await Api.setOffers(offersModel);

    ProgressCircleDialog.dismiss(context);

    Navigator.pop(context , true) ;

  }
}
