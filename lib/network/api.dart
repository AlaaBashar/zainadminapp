import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/admin_model.dart';
import '../models/areas_model.dart';
import '../models/complaint_model.dart';
import '../models/contract_model.dart';
import '../models/ministries_model.dart';
import '../models/offers_model.dart';
import '../models/suggestions_model.dart';
import '../models/user_model.dart';
import '../models/visits_model.dart';
import '../utils.dart';
import 'Fcm.dart';
import 'auth.dart';
import 'constants.dart';

class Api {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Future<UserApp?> getUserFromUid(String uid) async {
    DocumentSnapshot documentSnapshot =
        await db.collection(CollectionsKey.USERS).doc(uid).get();

    if (documentSnapshot.data() != null) {
      Map<String, dynamic>? map =
          documentSnapshot.data() as Map<String, dynamic>?;
      UserApp userApp = UserApp.fromJson(map!);

      return userApp;
    }
    return null;
  }

  static Future<AdminApp?> getAdminFromUid(String uid) async {
    DocumentSnapshot documentSnapshot =
        await db.collection(CollectionsKey.ADMINS).doc(uid).get();

    if (documentSnapshot.data() != null) {
      Map<String, dynamic>? map =
          documentSnapshot.data() as Map<String, dynamic>?;
      AdminApp userApp = AdminApp.fromJson(map!);

      return userApp;
    }
    return null;
  }

  static Future setNewMinistries(MinistriesModel model) async {
    DocumentReference doc = db.collection(CollectionsKey.MINISTRIES).doc();
    model.id = doc.id;
    await doc.set(model.toJson());
  }

  static Future updateMinistries(MinistriesModel model) async {
    DocumentReference doc =
        db.collection(CollectionsKey.MINISTRIES).doc(model.id);
    await doc.update(model.toJson());
  }

  static Future updateUser(UserApp userApp) async {
    DocumentReference doc =
        db.collection(CollectionsKey.USERS).doc(userApp.uid);

    await doc.update({'isBlocked': !userApp.isBlocked!});
  }

  static Future<dynamic> uploadFile({required File imageFile, required String folderPath}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference reference =
        FirebaseStorage.instance.ref().child(folderPath).child(fileName);

    TaskSnapshot storageTaskSnapshot = await reference.putFile(imageFile);
    // TaskSnapshot storageTaskSnapshot =  uploadTask.snapshot;

    print(storageTaskSnapshot.ref.getDownloadURL());

    var dowUrl = await storageTaskSnapshot.ref.getDownloadURL();

    return dowUrl;
  }

  static Future<dynamic> deleteFileByUrl({required String url}) async {
    return FirebaseStorage.instance.refFromURL(url).delete();
  }

  static Future<List<MinistriesModel>> getMinistries() async {
    List<MinistriesModel> ministriesList = [];
    QuerySnapshot querySnapshot =
        await db.collection(CollectionsKey.MINISTRIES).get();

    ministriesList = querySnapshot.docs
        .map((e) => MinistriesModel.fromJson(
              e.data() as Map<String, dynamic>,
            ))
        .toList();

    return ministriesList;
  }

  static Future<List<UserApp>> getUsers() async {
    List<UserApp> usersList = [];

    QuerySnapshot querySnapshot =
        await db.collection(CollectionsKey.USERS).get();

    usersList = querySnapshot.docs
        .map((e) => UserApp.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    return usersList;
  }

  static Future<List<ComplaintModel>> getComplaints() async {
    List<ComplaintModel> complaintList = [];

    QuerySnapshot querySnapshot =
        await db.collection(CollectionsKey.COMPLAINTS).get();

    complaintList = querySnapshot.docs
        .map((e) => ComplaintModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    if(complaintList.isNotEmpty) {
      complaintList.sort((a, b) => b.date!.compareTo(a.date!));
    }

    return complaintList;
  }

  static Future updateComplaint(ComplaintModel complaintModel) async {
    DocumentReference doc =
        db.collection(CollectionsKey.COMPLAINTS).doc(complaintModel.id);

    await doc.update({
      'complaintStatus': getStringFromEnum(complaintModel.complaintStatus!)
    });

    String status = '';
    if (complaintModel.complaintStatus == ComplaintStatus.Pending) {
      status = 'قيد الانتظار';
    } else if (complaintModel.complaintStatus == ComplaintStatus.InProgress) {
      status = 'قيد المعالجة';
    } else if (complaintModel.complaintStatus == ComplaintStatus.Completed) {
      status = 'تمة المعالجة';
    } else if (complaintModel.complaintStatus == ComplaintStatus.Canceled) {
      status = 'ملغية';
    }

    Fcm.sendNotificationToUser(
        'تحديث جديد للشكوى ${complaintModel.title}',
        'تم تحديث حالة الشكوى الخاصة بك ل ( $status )',
        complaintModel.userUid!);
  }

  static Future<List<SuggestionModel>> getSuggestions() async {
    List<SuggestionModel> suggestionsList = [];

    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.SUGGESTIONS)
        .get();

    suggestionsList = querySnapshot.docs
        .map((e) => SuggestionModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    if (suggestionsList.isNotEmpty) {
      suggestionsList.sort((a, b) => b.date!.compareTo(a.date!));
    }

    return suggestionsList;
  }

  static Future updateSuggestion(SuggestionModel suggestionModel) async {
    DocumentReference doc = db.collection(CollectionsKey.SUGGESTIONS).doc(suggestionModel.id);

    await doc.update({
      'suggestionsStatus': getStringFromEnum(suggestionModel.suggestionsStatus!)
    });

    String status = '';
    if (suggestionModel.suggestionsStatus == SuggestionStatus.Pending) {
      status = 'قيد الانتظار';
    } else if (suggestionModel.suggestionsStatus == SuggestionStatus.Approve) {
      status = 'مقبول';
    } else if (suggestionModel.suggestionsStatus == SuggestionStatus.Rejected) {
      status = 'مرفوض';
    }

    print('user : ${suggestionModel.userUid}');
    Fcm.sendNotificationToUser(
        'تحديث جديد للاقتراح ${suggestionModel.title}',
        'تم تحديث حالة الاقتراح الخاصة بك ل ( $status )',
        suggestionModel.userUid!);
  }

  static Future<List<ContractModel>> getContracts() async {
    List<ContractModel> contractsList = [];

    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.CONTRACTS)
        .get();

    contractsList = querySnapshot.docs
        .map((e) => ContractModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    if (contractsList.isNotEmpty)
      contractsList.sort((a, b) => b.date!.compareTo(a.date!));

    return contractsList;
  }

  static Future editContract(ContractModel model,String docId) async {
    model.id = docId;
    CollectionReference  doc = db.collection(CollectionsKey.CONTRACTS);
    await doc.doc(model.id).update(model.toJson());

  }

  static Future<List<VisitsModel>> getVisits() async {
    List<VisitsModel> visitsList = [];

    QuerySnapshot querySnapshot = await db
        .collection(CollectionsKey.VISITS)
        .get();

    visitsList = querySnapshot.docs
        .map((e) => VisitsModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    if (visitsList.isNotEmpty)
      visitsList.sort((a, b) => b.date!.compareTo(a.date!));

    return visitsList;
  }

  static Future setOffers(OffersModel model) async {
    DocumentReference doc = db.collection(CollectionsKey.OFFERS).doc();
    await doc.set(model.toJson());
  }
  static Future setAreas(AreasModel model) async {
    DocumentReference doc = db.collection(CollectionsKey.AREAS).doc();
    model.id = doc.id;
    await doc.set(model.toJson());
  }
  static Future<List<AreasModel>> getAreas() async {
    List<AreasModel> areasModel = [];

    QuerySnapshot querySnapshot =
    await db.collection(CollectionsKey.AREAS).get();

    areasModel = querySnapshot.docs
        .map((e) => AreasModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    // if(offerModel.isNotEmpty) {
    //   offerModel.sort((a, b) => b.date!.compareTo(a.date!));
    // }

    return areasModel;
  }

  static Future<List<OffersModel>> getOffers() async {
    List<OffersModel> offerList = [];

    QuerySnapshot querySnapshot =
    await db.collection(CollectionsKey.OFFERS).get();

    offerList = querySnapshot.docs
        .map((e) => OffersModel.fromJson(e.data() as Map<String, dynamic>))
        .toList();

    // if(offerModel.isNotEmpty) {
    //   offerModel.sort((a, b) => b.date!.compareTo(a.date!));
    // }

    return offerList;
  }

  static Future onEditAreas(AreasModel? model,String? docId) async {
    model!.id = docId;
    DocumentReference doc = db.collection(CollectionsKey.AREAS).doc(model.id);
    await doc.update(model.toJson());

    // DocumentReference doc = db.collection(CollectionsKey.SUGGESTIONS).doc(model!.id);
    // await doc.update({
    //   'isBlocked': !model.isBlocked,
    // });

  }


}
