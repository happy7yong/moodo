import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodo/auth_service.dart';
import 'package:moodo/diary_service.dart';
import 'package:provider/provider.dart';

class MoodSelector extends StatefulWidget {
  final Function(String) onMoodSelected;
  final String currentDocId;

  const MoodSelector(
      {super.key, required this.onMoodSelected, required this.currentDocId});

  @override
  _MoodSelectorState createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return SizedBox(
      height: 200,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                color: const Color.fromRGBO(219, 219, 219, 1),
                height: 4,
                width: 40,
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                '오늘 하루의 감정을 입혀볼까요?',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('Diary')
                          .doc(widget.currentDocId) // 전달된 문서 ID 사용
                          .update({'mood': 'positive'});
                      widget.onMoodSelected('positive');
                    },
                    child: Image.asset(
                      'assets/images/moodEmoji/positiveMood.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('Diary')
                          .doc(widget.currentDocId) // 전달된 문서 ID 사용
                          .update({'mood': 'neutral'});
                      widget.onMoodSelected('neutral');
                    },
                    child: Image.asset(
                      'assets/images/moodEmoji/neutralityMood.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection('Diary')
                          .doc(widget.currentDocId) // 전달된 문서 ID 사용
                          .update({'mood': 'negative'});
                      widget.onMoodSelected('negative');
                    },
                    child: Image.asset(
                      'assets/images/moodEmoji/negativeMood.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
