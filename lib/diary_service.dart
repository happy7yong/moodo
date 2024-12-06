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
    await DiaryCollection.add({
      'date': date,
      'content': content,
      'uid': uid,
      'mood': mood,
    });
  }

  //수정
  void update(String docId, String date, String uid, String content) async {
    await DiaryCollection.doc(docId).update({
      'content': content,
    });
    notifyListeners();
  }

  void delete(String date, String uid, String content) async {
    // bucket 삭제
  }
}
