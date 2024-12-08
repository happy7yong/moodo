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
  void create(String date, String uid, String? content, String? mood) async {
    if (date.isNotEmpty && uid.isNotEmpty) {
      await DiaryCollection.add({
        'date': date,
        'content': content,
        'uid': uid,
        'mood': mood,
      });
    } else {
      print("날짜와 UID는 필수 값입니다.");
    }
  }

  //수정
  void update(String docId, String date, String uid, String? content,
      String? mood) async {
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
  Future<bool> hasDiary(String userId, String date) async {
    final diaryData = await getDiaryByDate(userId, date);
    return diaryData != null;
  }
}
