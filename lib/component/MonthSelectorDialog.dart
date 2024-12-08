import 'package:flutter/material.dart';

class ShowMonthDialog extends StatelessWidget {
  const ShowMonthDialog({super.key});

  // showDialog 호출을 별도의 메소드로 분리
  void _showMonthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("월 선택"),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(12, (index) {
                final month = index + 1;
                return ListTile(
                  title: Text("${2024}년 $month월"),
                  onTap: () {
                    Navigator.of(context).pop();
                    print("선택된 월: ${2024}년 $month월");
                  },
                );
              }),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showMonthDialog(context); // 리팩토링한 메소드 호출
          },
          child: const Text("월 선택 모달 열기"),
        ),
      ),
    );
  }
}
