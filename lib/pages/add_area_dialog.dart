import 'package:flutter/material.dart';

import '../models/areas_model.dart';
import '../models/offers_model.dart';
import '../network/api.dart';
import '../utils.dart';
import '../widget/text_field_app.dart';


class AddAreaDialog extends StatefulWidget {
  const AddAreaDialog({Key? key}) : super(key: key);

  @override
  _AddAreaDialogState createState() => _AddAreaDialogState();
}

class _AddAreaDialogState extends State<AddAreaDialog> {
  TextEditingController stateController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اضافة منطقة جديدة'),

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
                  controller: stateController,
                  hintText: 'المنطقة',
                  icon: const Icon(Icons.title),
                  validator: (str)=> str!.isEmpty ? 'هذا الحقل مطلوب' : null,
                  margin: const EdgeInsets.symmetric(horizontal: 0 , vertical: 16.0),
                ),
                const SizedBox(height: 16.0,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onAddArea,
                    child: const Text('اضافة منطقة'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onAddArea() async{

    if(!formKey.currentState!.validate()) {
      return;
    }

    String state = stateController.text ;
    ProgressCircleDialog.show(context);

    AreasModel areasModel = AreasModel();
    areasModel
      ..state = state
    ..isBlocked =false;


    await Api.setAreas(areasModel);

    ProgressCircleDialog.dismiss(context);

    Navigator.pop(context , true) ;

  }
}
