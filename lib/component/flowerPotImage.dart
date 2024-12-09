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
  static const String potRose = 'assets/images/pot/potRose.png';
  static const String potSilver = 'assets/images/pot/potSilver.png';
  static const String potPeony = 'assets/images/pot/potPeony.png';
  static const String potLily = 'assets/images/pot/potLily.png';
  static const String potSun = 'assets/images/pot/potSun.png';
  static const String potHydran = 'assets/images/pot/potHydran.png';

  String getPotImage(
      int dataCount, int positiveCount, int neutralCount, int negativeCount) {
    if (dataCount >= 18) {
      if (positiveCount > neutralCount && neutralCount > negativeCount) {
        return potRose; // 긍 > 중 > 부 : 장미꽃
      } else if (positiveCount > neutralCount && neutralCount < negativeCount) {
        return potPeony; // 긍 > 부 > 중 : 모란꽃
      } else if (neutralCount > positiveCount &&
          positiveCount > negativeCount) {
        return potSun; // 중 > 긍 > 부 : 해바라기꽃
      } else if (neutralCount > negativeCount &&
          positiveCount < negativeCount) {
        return potLily; // 중 > 부 > 긍 : 백합꽃
      } else if (negativeCount > neutralCount && neutralCount > positiveCount) {
        return potSilver; // 부 > 중 > 긍 : 은방울꽃
      } else if (negativeCount > positiveCount &&
          positiveCount > neutralCount) {
        return potHydran; // 부 > 긍 > 중 : 수국꽃
      } else {
        return step_3;
      }
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
        // 초기화된 moodCounts 정의
        final moodCounts = {
          'positive': 0,
          'neutral': 0,
          'negative': 0,
        };

        // Firestore 데이터를 기반으로 moodCounts 계산
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          for (var doc in snapshot.data!.docs) {
            final mood = doc['mood'] ?? 'default';
            if (moodCounts.containsKey(mood)) {
              moodCounts[mood] = moodCounts[mood]! + 1;
            }
          }
        }

        final positiveCount = moodCounts['positive']!;
        final neutralCount = moodCounts['neutral']!;
        final negativeCount = moodCounts['negative']!;
        final dataCount = positiveCount + neutralCount + negativeCount;
        final potImage =
            getPotImage(dataCount, positiveCount, neutralCount, negativeCount);

        return GestureDetector(
          onTap: () async {
            if (isEndOfMonth && dataCount >= 18) {
              final moodStats = await getMoodStatistics();

              print("moodStats: $moodStats");
              print("Positive Count: $positiveCount");
              print("Neutral Count: $neutralCount");
              print("Negative Count: $negativeCount");

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Flowerroompage(
                    moodStats: moodStats,
                    month: widget.selectedMonth,
                    positiveCount: positiveCount,
                    neutralCount: neutralCount,
                    negativeCount: negativeCount,
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
