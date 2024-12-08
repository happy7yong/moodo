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

  String potImage = Default_pot;
  int dataCount = 0;

  @override
  void initState() {
    super.initState();
    checkDataCount();
  }

  Future<void> checkDataCount() async {
    final currentMonth = widget.selectedMonth.toString().padLeft(2, '0');
    final currentTime = DateTime.now();
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Diary')
        .where('date',
            isLessThan:
                '${currentTime.year}-${(widget.selectedMonth + 1).toString().padLeft(2, '0')}-01')
        .get();

    setState(() {
      dataCount = querySnapshot.docs.length;

      if (dataCount >= 5) {
        potImage = step_2;
      } else if (dataCount >= 10) {
        potImage = step_3;
      } else if (dataCount >= 10) {
        potImage = step_4;
      } else {
        potImage = Default_pot;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
  }
}
