import 'package:flutter/material.dart';

class Flowerroompage extends StatelessWidget {
  //꽃 이미지
  static const String FlowerRose = "assets/images/flower/flowerRose.png";
  static const String FlowerSilver = "assets/images/flower/flowerSilver.png";
  static const String FlowerPeony = "assets/images/flower/flowerPeony.png";
  static const String FlowerHydran = "assets/images/flower/flowerHydran.png";
  static const String FlowerLily = "assets/images/flower/flowerLliy.png";
  static const String FlowerSun = "assets/images/flower/flowerSun.png";

  final Map<String, int> moodStats;
  final int month;

  const Flowerroompage({
    super.key,
    required this.moodStats,
    required this.month,
  });

  @override
  Widget build(BuildContext context) {
    final String flowerName;
    final String flowerImage;
    //mood count
    final positiveCount = moodStats['positive'] ?? 0;
    final neutralCount = moodStats['neutral'] ?? 0;
    final negativeCount = moodStats['negative'] ?? 0;

    //mood 비율에 따른 꽃 종류
    if (positiveCount > neutralCount && neutralCount > negativeCount) {
      flowerImage = FlowerRose;
      flowerName = '장미꽃';
    } else if (positiveCount < neutralCount && neutralCount < negativeCount) {
      flowerImage = FlowerSilver;
      flowerName = '은방울꽃';
    } else {
      flowerImage = FlowerSilver;
      flowerName = '기본 (은방울)꽃';
    }

    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    '$month월',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    '당신의 꽃은,',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset(
                    flowerImage,
                    width: 400,
                    height: 400,
                  ),
                  Text(
                    '$flowerName이 피어났어요',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMoodStatCard(
                  'Positive',
                  moodStats['positive'] ?? 0,
                  Colors.red,
                ),
                _buildMoodStatCard(
                  'Neutral',
                  moodStats['neutral'] ?? 0,
                  Colors.yellow,
                ),
                _buildMoodStatCard(
                  'Negative',
                  moodStats['negative'] ?? 0,
                  Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodStatCard(String mood, int count, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Text(
            count.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          mood,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
