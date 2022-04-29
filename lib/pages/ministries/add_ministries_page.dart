import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/ministries_model.dart';
import '../../network/api.dart';
import '../../network/constants.dart';
import '../../utils.dart';
import '../../widget/text_field_app.dart';


class AddMinistriesPage extends StatefulWidget {
  const AddMinistriesPage({Key? key}) : super(key: key);

  @override
  _AddMinistriesPageState createState() => _AddMinistriesPageState();
}

class _AddMinistriesPageState extends State<AddMinistriesPage> {
  FilePickerResult? filePicker;

  TextEditingController titleController = TextEditingController();

  File imageFile = File('');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Visibility(
                visible: filePicker == null,
                child: IconButton(
                  onPressed: onPicker,
                  icon: const Icon(FontAwesomeIcons.camera),
                  iconSize: 70,
                ),
              ),
              Visibility(
                visible: filePicker != null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.file(
                    imageFile,
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const Text(
                'اضغط على الكاميرا لتحميل صورة',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              TextFieldApp(
                controller: titleController,
                hintText: 'ادخل اسم الوزارة',
                icon: const Icon(
                  Icons.account_balance_sharp,
                ),
                onActionComplete: onAdd,
              ),
              const SizedBox(
                height: 32.0,
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: onAdd,
                  child: const Text(
                    'اضافة',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onPicker() async {
    filePicker = await FilePicker.platform.pickFiles();
    if (filePicker == null) return;

    setState(() {
      imageFile = File(filePicker!.files.first.path!);
    });
  }

  void onAdd() async {
    String title = titleController.text;

    if (imageFile.path.isEmpty) {
      showSnackBar(
        context,
        'الرجاء اختيار صورة اولا',
        isError: true,
      );
      return;
    }
    if (title.isEmpty) {
      showSnackBar(
        context,
        'ادخل اسم الوزارة',
        isError: true,
      );
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    MinistriesModel model = MinistriesModel();

      model.title = title;

    ProgressCircleDialog.show(context);
    String? imageUrl = await Api.uploadFile(
      imageFile: imageFile,
      folderPath: CollectionsKey.MINISTRIES,
    );

    if (imageUrl == null) {
      showSnackBar(
        context,
        'حدث مشكلة في رفع الملف ، الرجاء المحاولة مرة اخرى',
        isError: true,
      );
      ProgressCircleDialog.dismiss(context);
      return;
    }
    model.imageUrl = imageUrl;

    await Api.setNewMinistries(model).catchError((onError) {
      showSnackBar(
        context,
        'حدث مشكلة في اضاقة وزارة جديدة ، الرجاء المحاولة مرة اخرى',
        isError: true,
      );
    });

    showSnackBar(context, 'تمة العملة بنجاح', isSuccess: true);
    setState(() {
      titleController.text = '';
      imageFile = File('');
      filePicker = null;
    });
    ProgressCircleDialog.dismiss(context);
  }
}
