import 'package:flutter/material.dart';

import '../../dialog/edit_ministries_dialog.dart';
import '../../models/ministries_model.dart';
import '../../network/api.dart';
import '../../utils.dart';
import '../../widget/reusable_cached_network_image.dart';


class EditMinistriesPage extends StatefulWidget {
  const EditMinistriesPage({Key? key}) : super(key: key);

  @override
  _EditMinistriesPageState createState() => _EditMinistriesPageState();
}

class _EditMinistriesPageState extends State<EditMinistriesPage> {
  List<MinistriesModel> ministriesList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMinistries();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: ministriesList.isNotEmpty
          ? RefreshIndicator(
              onRefresh: loadMinistries,
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(vertical: 16.0 , horizontal: 8),
                itemCount: ministriesList.length,
                itemBuilder: (_, index) {
                  MinistriesModel model = ministriesList[index];

                  return InkWell(
                    onTap: ()=>onEdit(model , index),
                    borderRadius: BorderRadius.circular(8.0),

                    child: Card(
                      color: Colors.white,
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        children: [

                          const SizedBox(height: 16.0,),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(35.0),
                            child: ReusableCachedNetworkImage(
                              imageUrl: model.imageUrl ?? '',
                              width: 70.0,
                              height: 70.0,
                              fit: BoxFit.fill,
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            '${model.title}',
                            style: const TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          const Spacer(),
                          Visibility(
                            visible: !model.isVisible!,
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red[600],
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                  )),
                              child: const Text(
                                'مخفي',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5
                ),
              ),
            )
          : getCenterCircularProgress(),
    );
  }

  Future loadMinistries() async {
    ministriesList = await Api.getMinistries();
    setState(() {

    });
  }

  void onEdit(MinistriesModel model , int index) async{

    MinistriesModel? result = await showDialog(context: context, builder: (_){
      return EditMinistriesDialog(model: model);
    });

    if(result == null) {
      return ;
    }

    setState(() {
      ministriesList[index] = result;
    },);
  }
}
