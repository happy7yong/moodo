import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final selectedMonth = widget.selectedMonth.toString().padLeft(2, '0');
    final nextMonth = (widget.selectedMonth + 1).toString().padLeft(2, '0');

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Diary')
          .where('date',
              isGreaterThanOrEqualTo: '${currentTime.year}-$selectedMonth-01')
          .where('date', isLessThan: '${currentTime.year}-$nextMonth-01')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final dataCount = snapshot.data?.docs.length ?? 0;
        final potImage = getPotImage(dataCount);

        return GestureDetector(
          onTap: () {
            print("화분이 클릭되었습니다!");
            print('현재 월(${widget.selectedMonth})의 데이터 개수: $dataCount');
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
