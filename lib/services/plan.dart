import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miel_work_shift_web/common/functions.dart';
import 'package:miel_work_shift_web/models/plan.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanService {
  String collection = 'plan';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Future<PlanModel?> selectData({
    required String id,
  }) async {
    PlanModel? ret;
    await firestore
        .collection(collection)
        .where('id', isEqualTo: id)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = PlanModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamList({
    required String? organizationId,
    required String? groupId,
    required List<String> categories,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('groupId', isEqualTo: groupId != '' ? groupId : null)
        .where('category', whereIn: categories.isNotEmpty ? categories : null)
        .orderBy('startedAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? streamListDate({
    required String? organizationId,
    required String? groupId,
    required DateTime date,
    required List<String> categories,
  }) {
    Timestamp startAt = convertTimestamp(date, false);
    Timestamp endAt = convertTimestamp(date, true);
    return FirebaseFirestore.instance
        .collection(collection)
        .where('organizationId', isEqualTo: organizationId ?? 'error')
        .where('groupId', isEqualTo: groupId != '' ? groupId : null)
        .where('category', whereIn: categories.isNotEmpty ? categories : null)
        .orderBy('startedAt', descending: false)
        .startAt([startAt]).endAt([endAt]).snapshots();
  }

  List<sfc.Appointment> generateListAppointment({
    required QuerySnapshot<Map<String, dynamic>>? data,
    bool shift = false,
  }) {
    List<sfc.Appointment> ret = [];
    for (DocumentSnapshot<Map<String, dynamic>> doc in data!.docs) {
      PlanModel plan = PlanModel.fromSnapshot(doc);
      ret.add(sfc.Appointment(
        id: plan.id,
        resourceIds: plan.userIds,
        subject: '[${plan.category}]${plan.subject}',
        startTime: plan.startedAt,
        endTime: plan.endedAt,
        isAllDay: plan.allDay,
        color: shift ? plan.categoryColor.withOpacity(0.3) : plan.categoryColor,
        notes: 'plan',
        recurrenceRule: plan.getRepeatRule(),
      ));
    }
    return ret;
  }
}
