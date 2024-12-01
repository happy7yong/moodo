import 'package:flutter/material.dart';

class Diarypage extends StatelessWidget {
  const Diarypage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/defaultMood.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(height: 10),
            Container(
              width: 300,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromRGBO(255, 221, 173, 1), width: 1),
                  borderRadius: BorderRadius.circular(15)),
              child: const Column(
                children: [
                  Text(
                    '오늘의 일기를 모두 기록하면',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    '오늘의 감정 이모티콘이 생겨요!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('2024.11.13', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '수요일',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "오늘은 어떤 하루를 보내셨나요?",
                      hintStyle: TextStyle(
                          color: Color.fromRGBO(212, 212, 212, 1),
                          fontSize: 18),
                      border: InputBorder.none),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
                        title: const Text('모달제목'),
                        content: const Text('안녕하세요'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('닫기'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(53, 47, 47, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    minimumSize: const Size(120, 50),
                    elevation: 0),
                child: const Text(
                  '기록 완료',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                )),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
