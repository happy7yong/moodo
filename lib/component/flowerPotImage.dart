import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moodo/screen/flowerRoomPage.dart';

class FlowerpotImage extends StatefulWidget {
  final int selectedMonth;

  const FlowerpotImage({super.key, required this.selectedMonth});

  @override
  _FlowerpotImageState createState() => _FlowerpotImageState();
}

class _FlowerpotImageState extends State<FlowerpotImage> {
  static const String Default_pot = 'assets/images/pot/default-pot.png';
  static const String step_2 = 'assets/images/pot/pot2.png';
  static const String step_3 = 'assets/images/pot/pot3.png';
  static const String step_4 = 'assets/images/pot/pot4.png';

  String getPotImage(int dataCount) {
    if (dataCount >= 18) {
      return step_4;
    } else if (dataCount >= 10) {
      return step_3;
    } else if (dataCount >= 5) {
      return step_2;
    } else {
      return Default_pot;
    }
  }

  Future<Map<String, int>> getMoodStatistics() async {
    final currentTime = DateTime.now();
    final nextMonth = (widget.selectedMonth + 1).toString().padLeft(2, '0');
    final selectedMonth = widget.selectedMonth.toString().padLeft(2, '0');

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Diary')
        .where('date',
            isGreaterThanOrEqualTo: '${currentTime.year}-$selectedMonth-01')
        .where('date', isLessThan: '${currentTime.year}-$nextMonth-01')
        .get();

    final moodCounts = {
      'positive': 0,
      'neutral': 0,
      'negative': 0,
    };

    for (var doc in querySnapshot.docs) {
      final mood = doc['mood'] ?? 'default';
      if (moodCounts.containsKey(mood)) {
        moodCounts[mood] = moodCounts[mood]! + 1;
      }
    }

    return moodCounts;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    //월의 마지막일자
    final isEndOfMonth = DateTime(now.year, now.month, now.day)
        .isAfter(DateTime(now.year, widget.selectedMonth, 28)); // 28일 이후 조건

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Diary')
          .where('date',
              isGreaterThanOrEqualTo: '${now.year}-${widget.selectedMonth}-01')
          .where('date',
              isLessThan: '${now.year}-${widget.selectedMonth + 1}-01')
          .snapshots(),
      builder: (context, snapshot) {
        final dataCount = snapshot.data?.docs.length ?? 0;
        final potImage = getPotImage(dataCount);

        return GestureDetector(
          onTap: () async {
            if (isEndOfMonth) {
              final moodStats = await getMoodStatistics();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Flowerroompage(
                    moodStats: moodStats,
                    month: widget.selectedMonth,
                  ),
                ),
              );
            } else {
              print("화분이 클릭되었습니다!");
              print('현재 월(${widget.selectedMonth})의 데이터 개수: $dataCount');
            }
          },
          child: Image.asset(
            potImage,
            width: 100,
            height: 100,
          ),
        );
      },
    );
  }
}
