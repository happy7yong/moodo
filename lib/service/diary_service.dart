import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiaryService extends ChangeNotifier {
  final DiaryCollection = FirebaseFirestore.instance.collection('Diary');

  Future<QuerySnapshot> read(String uid) async {
    return DiaryCollection.where('uid', isEqualTo: uid).get();
  }

  // 실시간 데이터 변경
  Stream<QuerySnapshot> stream(String uid) {
    return DiaryCollection.where('uid', isEqualTo: uid).snapshots();
  }

  //생성
  void create(String date, String uid, String content, String? mood) async {
    if (date.isNotEmpty && uid.isNotEmpty) {
      await DiaryCollection.add({
        'date': date,
        'content': content,
        'uid': uid,
        'mood': mood,
      });
    }
  }

  //수정
  void update(String? docId, String content) async {
    await DiaryCollection.doc(docId).update({
      'content': content,
    });
    notifyListeners();
  }

//감정수정
  Future<void> Moodupdate(String docId, String mood) async {
    await DiaryCollection.doc(docId).update({
      'mood': mood,
    });
    notifyListeners();
  }

  /// 특정 날짜의 다이어리를 가져오기
  Future<Map<String, dynamic>?> getDiaryByDate(String uid, String date) async {
    final query = await DiaryCollection.where('uid', isEqualTo: uid)
        .where('date', isEqualTo: date)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      return query.docs.first.data();
    }
    return null;
  }

  /// 특정 날짜의 데이터가 있는지 확인하는 메서드
  Future<bool> hasDiary(String userId, String content) async {
    final diaryData = await getDiaryByDate(userId, content);
    return diaryData != null;
  }

  Stream<QuerySnapshot> streamForMonth(String userId, int year, int month) {
    final startDate = formatDate("$year-$month-1");
    final endDate = formatDate("$year-${month + 1}-0");

    return FirebaseFirestore.instance
        .collection('diaryEntries')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .snapshots();
  }

  String formatDate(String date) {
    final parts = date.split('-');
    if (parts.length == 3) {
      return "${parts[0]}-${int.parse(parts[1])}-${int.parse(parts[2])}";
    }
    return date;
  }

  Future<Map<String, bool>> getDiaryExistenceForMonth(
      String userId, int year, int month) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);

    Map<String, bool> diaryExistence = {};

    // 해당 월의 모든 날짜에 대해 초기화
    for (int day = 1; day <= endDate.day; day++) {
      String dateString = formatDate("$year-$month-$day");
      diaryExistence[dateString] = false;
    }

    // Firestore에서 해당 월의 데이터 가져오기
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('diaryEntries')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: formatDate("$year-$month-1"))
        .where('date', isLessThanOrEqualTo: formatDate("$year-${month + 1}-0"))
        .get();

    // 가져온 데이터로 diaryExistence 업데이트
    for (var doc in snapshot.docs) {
      String date = doc['date'];
      diaryExistence[date] = true;
    }

    return diaryExistence;
  }
}
