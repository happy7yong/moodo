import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiaryService extends ChangeNotifier {
  final DiaryCollection = FirebaseFirestore.instance.collection('Diary');

  Future<QuerySnapshot> read(String uid) async {
    // 내 uid에 맞는 bucketList 가져오기
    return DiaryCollection.where('uid', isEqualTo: uid).get();
  }

  void create(String date, String uid, String content) async {
    await DiaryCollection.add({
      'date': date,
      'content': content,
      'uid': uid,
    });
  }

  void update(String docId, bool isDone) async {
    // bucket isDone 업데이트
  }

  void delete(String docId) async {
    // bucket 삭제
  }
}
