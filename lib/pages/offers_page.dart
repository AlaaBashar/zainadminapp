import 'package:flutter/material.dart';
import '../dialog/yes_or_no_dialog.dart';
import '../models/offers_model.dart';
import '../network/api.dart';
import '../utils.dart';
import 'add_offer_dialog.dart';


class OffersPage extends StatefulWidget {
  const OffersPage({Key? key}) : super(key: key);

  @override
  _OffersPageState createState() => _OffersPageState();
}

class _OffersPageState extends State<OffersPage> {
  List<OffersModel>? offersList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMyOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاقتراحات'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: onAdd,
      ),
      body: Container(
        child: offersList != null
            ? ListView.builder(
          itemCount: offersList!.length,
          padding: const EdgeInsets.all(8.0),
          itemBuilder: (_, index) {
            OffersModel model = offersList![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const <Widget>[
                          Expanded(child: Divider()),
                          Text(
                            " العرض ",
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      offerText(labels:'السرعة' ,text: model.speed),
                      const SizedBox(
                        height: 5.0,
                      ),
                      offerText(labels:'السعر' ,text:'${model.price}\$'),
                      const SizedBox(
                        height: 8.0,
                      ),
                      offerText(labels:'الخصم' ,text: '${model.discount}\$'),
                      const SizedBox(
                        height: 8.0,
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
                              color: model.isAvailable!
                                  ? Colors.red[600]
                                  : Colors.green[600]),
                          child: Text(
                            model.isAvailable! ? 'محظور' : 'فعال',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
  Widget offerText({dynamic text, String? labels}) {
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
  void loadMyOffers() async {
    offersList = await Api.getOffers();
    setState(() {});
  }
  void onBlock(OffersModel offerModel, int index,)  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialogYesORNo(
            title: !offerModel.isAvailable! ? 'حظر العرض' : 'الغاء الحظر',
            content:
            'هل انت متأكد من ${offerModel.isAvailable! ? 'الغاء ' : ''}حظر عرض ${'${offerModel.speed}'}',
            onYes: () async {

              ProgressCircleDialog.show(context);
              offerModel.isAvailable = !offerModel.isAvailable!;

              await Api.onEditOffer(offerModel,offerModel.id);

              ProgressCircleDialog.dismiss(context);


              offersList![index] = offerModel;

              setState(() {});
              Navigator.pop(context);
            },
          );
        });
  }
  void onAdd() async {
    bool? result = await showDialog(
        context: context,
        builder: (_) {
          return const AddOfferDialog();
        });

    if (result == null) return;

    setState(() {
      offersList = null;
      loadMyOffers();
    });
  }
}
