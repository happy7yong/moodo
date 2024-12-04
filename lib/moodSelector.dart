import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final Function(String) onMoodSelected;

  const MoodSelector({super.key, required this.onMoodSelected});

  void _showMoodSelector(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: const Color.fromRGBO(219, 219, 219, 1),
                height: 4,
                width: 40,
              ),
              const Text(
                '오늘 하루의 감정을 입혀볼까요?',
                style: TextStyle(fontSize: 17),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      onMoodSelected('positive'); // 감정명 전달
                    },
                    child: Image.asset(
                      'assets/images/moodEmoji/positiveMood.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onMoodSelected('neutral');
                    },
                    child: Image.asset(
                      'assets/images/moodEmoji/neutralityMood.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onMoodSelected('negative');
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
