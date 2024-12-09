import 'package:flutter/material.dart';

class Flowerroompage extends StatelessWidget {
  //꽃 이미지
  static const String FlowerRose = "assets/images/flower/flowerRose.png";
  static const String FlowerSilver = "assets/images/flower/flowerSilver.png";
  static const String FlowerPeony = "assets/images/flower/flowerPeony.png";
  static const String FlowerHydran = "assets/images/flower/flowerHydran.png";
  static const String FlowerLily = "assets/images/flower/flowerLliy.png";
  static const String FlowerSun = "assets/images/flower/flowerSun.png";

  final Map<String, TextStyle> flowerStyles = {
    '장미꽃':
        TextStyle(fontSize: 20, color: const Color.fromARGB(255, 253, 92, 146)),
    '모란꽃': TextStyle(
        fontSize: 20, color: const Color.fromARGB(255, 255, 154, 196)),
    '해바라기꽃':
        TextStyle(fontSize: 20, color: const Color.fromARGB(255, 255, 195, 66)),
    '백합꽃': TextStyle(
        fontSize: 20, color: const Color.fromARGB(255, 132, 182, 207)),
    '은방울꽃': TextStyle(fontSize: 20, color: Color.fromRGBO(124, 149, 246, 1)),
    '수국꽃': TextStyle(
        fontSize: 20, color: const Color.fromARGB(255, 125, 116, 245)),
  };

  final TextStyle defaultStyle = TextStyle(fontSize: 20);

  final Map<String, int> moodStats;
  final int month;
  final int positiveCount;
  final int neutralCount;
  final int negativeCount;

  Flowerroompage({
    super.key,
    required this.moodStats,
    required this.month,
    required this.positiveCount,
    required this.neutralCount,
    required this.negativeCount,
  });

  @override
  Widget build(BuildContext context) {
    final String flowerName;
    final String flowerImage;

    //mood 비율에 따른 꽃 종류
    if (positiveCount > neutralCount && neutralCount > negativeCount) {
      flowerImage = FlowerRose;
      flowerName = '장미꽃'; // 긍 > 중 > 부
    } else if (positiveCount > neutralCount && neutralCount < negativeCount) {
      flowerImage = FlowerPeony;
      flowerName = '모란꽃'; // 긍 > 부 > 중
    } else if (neutralCount > positiveCount && positiveCount > negativeCount) {
      flowerImage = FlowerSun;
      flowerName = '해바라기꽃'; // 중 > 긍 > 부
    } else if (neutralCount > negativeCount && positiveCount < negativeCount) {
      flowerImage = FlowerLily;
      flowerName = '백합꽃'; // 중 > 부 > 긍
    } else if (negativeCount > neutralCount && neutralCount > positiveCount) {
      flowerImage = FlowerSilver;
      flowerName = '은방울꽃'; // 부 > 중 > 긍
    } else if (negativeCount > positiveCount && positiveCount > neutralCount) {
      flowerImage = FlowerHydran;
      flowerName = '수국꽃'; // 부 > 긍 > 중
    } else {
      flowerImage = FlowerSilver;
      flowerName = '기본 (은방울)꽃'; // 기본값
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
                    width: 500,
                    height: 500,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        flowerName,
                        style: flowerStyles[flowerName] ?? defaultStyle,
                      ),
                      Text(
                        '이 피어났어요',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
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
                  positiveCount,
                  Colors.red,
                ),
                _buildMoodStatCard(
                  'Neutral',
                  neutralCount,
                  Colors.yellow,
                ),
                _buildMoodStatCard(
                  'Negative',
                  negativeCount,
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
