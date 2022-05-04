import 'package:flutter/material.dart';
import 'package:zainadminapp/models/areas_model.dart';

import '../dialog/yes_or_no_dialog.dart';
import '../network/api.dart';
import '../utils.dart';
import 'add_area_dialog.dart';

class AreasPage extends StatefulWidget {
  const AreasPage({Key? key}) : super(key: key);

  @override
  State<AreasPage> createState() => _AreasPageState();
}

class _AreasPageState extends State<AreasPage> {
  List<AreasModel>? areasList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyAreas();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المناطق')),
      floatingActionButton: FloatingActionButton(
        onPressed: onAdd,
        child: const Icon(Icons.add),

      ),
      body:  Container(

        child: areasList != null
            ? ListView.builder(
          itemCount: areasList!.length,
          padding: const EdgeInsets.only(bottom: 80.0),
          itemBuilder: (_, index) {
            AreasModel model = areasList![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: const <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            " المنطقة ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'المكان : ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '${model.state}',
                                ),
                              ],
                            ),
                      const SizedBox(
                              height: 5.0,
                            ),
                      InkWell(
                        onTap: () => onBlock(model, index,),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                              ),
                              color: model.isBlocked!
                                  ? Colors.red[600]
                                  : Colors.green[600]),
                          child: Text(
                            model.isBlocked! ? 'محظور' : 'فعال',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        )
            : getCenterCircularProgress(),
      ),
    );
  }

  void loadMyAreas() async {
    areasList = await Api.getAreas();
    setState(() {});
  }

  void onAdd() async {
    bool? result = await showDialog(
        context: context,
        builder: (_) {
          return const AddAreaDialog();
        });

    if (result == null) return;

    setState(() {
      areasList = null;
      loadMyAreas();
    });
  }

  void onBlock(AreasModel areasModel, int index,)  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialogYesORNo(
            title: !areasModel.isBlocked! ? 'حظر المنطقة' : 'الغاء الحظر',
            content:
            'هل انت متأكد من ${areasModel.isBlocked! ? 'الغاء ' : ''}حظر ${'${areasModel.state}'}',
            onYes: () async {

              ProgressCircleDialog.show(context);
              areasModel.isBlocked = !areasModel.isBlocked!;

              await Api.onEditAreas(areasModel,areasModel.id);

              ProgressCircleDialog.dismiss(context);


              areasList![index] = areasModel;

              setState(() {});
              Navigator.pop(context);
            },
          );
        });
  }


}
