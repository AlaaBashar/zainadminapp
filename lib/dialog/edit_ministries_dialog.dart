import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zainadminapp/network/api.dart';

import '../models/ministries_model.dart';
import '../network/constants.dart';
import '../utils.dart';
import '../widget/reusable_cached_network_image.dart';
import '../widget/text_field_app.dart';


class EditMinistriesDialog extends StatefulWidget {
  final MinistriesModel model;

  const EditMinistriesDialog({Key? key, required this.model}) : super(key: key);

  @override
  _EditMinistriesDialogState createState() => _EditMinistriesDialogState();
}

class _EditMinistriesDialogState extends State<EditMinistriesDialog> {
  FilePickerResult? filePicker;

  TextEditingController titleController = TextEditingController();

  File imageFile = File('');

  bool? isVisible  ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.model.title!;
    isVisible = widget.model.isVisible ;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(
            color: Colors.black,
            width: 1,
          )),
      content: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Visibility(
                visible: filePicker == null,
                child: InkWell(
                  onTap: onPicker,
                  borderRadius: BorderRadius.circular(35.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35.0),
                    child: ReusableCachedNetworkImage(
                      imageUrl: widget.model.imageUrl ?? '',
                      width: 70.0,
                      height: 70.0,
                      fit: BoxFit.fill,
                    ),
                  ),
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
                'اضغط على الصورة لتحميل صورة جديدة',
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
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                onActionComplete: onEdit,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                children: [
                  const Text('اظهار الوزارة للمتسخدمين'),
                  const Spacer(),
                  CupertinoSwitch(
                      activeColor: Colors.blueAccent,
                      value: isVisible!,
                      onChanged: (value) {
                        setState(() {
                          isVisible = value;
                        });
                      })
                ],
              ),

              const SizedBox(
                height: 32.0,
              ),

              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: onEdit,
                  child: const Text(
                    'تعديل',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
              ),
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

  void onEdit() async {
    String title = titleController.text;

    if (title.isEmpty) {
      showSnackBar(
        context,
        'ادخل اسم الوزارة',
        isError: true,
      );
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    widget.model.title = title;
    widget.model.isVisible = isVisible;

    ProgressCircleDialog.show(context);

    if (imageFile.path.isNotEmpty) {
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
      await Api.deleteFileByUrl(url: widget.model.imageUrl ?? '');
      widget.model.imageUrl = imageUrl;
    }

    await Api.updateMinistries(widget.model).catchError(
      (onError) {
        showSnackBar(
          context,
          'حدث مشكلة في تحديث الوزارة ، الرجاء المحاولة مرة اخرى',
          isError: true,
        );
      },
    );
    ProgressCircleDialog.dismiss(context);

    Navigator.pop(context, widget.model);
  }
}
