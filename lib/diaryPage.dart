import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moodo/auth_service.dart';
import 'package:moodo/diary_service.dart';
import 'package:provider/provider.dart';

class Diarypage extends StatelessWidget {
  TextEditingController DiaryCollection = TextEditingController();
  final DateTime selectedDate;

  Diarypage({
    super.key,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<DiaryService>(
      builder: (context, DiaryService, child) {
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
                  height: 70,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromRGBO(255, 221, 173, 1),
                          width: 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '오늘의 일기를 모두 기록하면',
                        style: TextStyle(fontSize: 18, height: 1.1),
                      ),
                      Text(
                        '오늘의 감정 이모티콘이 생겨요!',
                        style: TextStyle(fontSize: 18, height: 1.1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일",
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        '수요일',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FutureBuilder<QuerySnapshot>(
                        future: DiaryService.read(user.uid),
                        builder: (context, snapshot) {
                          final documents =
                              snapshot.data?.docs ?? []; //문서들 가져오기
                          String initialText = '';

                          // 문서에서 오늘의 날짜와 일치하는 데이터 가져오기
                          final todayString =
                              "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

                          for (var doc in documents) {
                            final data = doc.data() as Map<String, dynamic>;
                            if (data['date'] == todayString) {
                              initialText = data['content'] ?? '';
                              break;
                            }
                          }

                          // 컨트롤러 값 설정
                          DiaryCollection.text = initialText;

                          return TextField(
                            controller: DiaryCollection,
                            decoration: const InputDecoration(
                                hintText: "오늘은 어떤 하루를 보내셨나요?",
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(212, 212, 212, 1),
                                    fontSize: 18),
                                border: InputBorder.none),
                            maxLines: null,
                          );
                        }),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            content: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Image.asset(
                                    'assets/images/diaryIcon.png',
                                    width: 130,
                                    height: 130,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    '오늘의 기록을 모두 작성하셨나요?',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(
                                    height: 13,
                                  ),
                                  const SizedBox(
                                    width: 300,
                                    child: Column(
                                      children: [
                                        Text(
                                          '현재 작성된 일기를 기반으로',
                                          style: TextStyle(
                                              fontSize: 17, height: 1),
                                        ),
                                        Text(
                                          '감정 이모티콘을 추천해드릴게요!',
                                          style: TextStyle(
                                              fontSize: 17, height: 1),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            actions: [
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final formattedDate =
                                        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                                    DiaryService.create(
                                      formattedDate,
                                      user.uid,
                                      DiaryCollection.text,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(
                                          255, 186, 101, 1),
                                      elevation: 0,
                                      minimumSize: const Size(140, 50)),
                                  child: const Text(
                                    '감정 받기',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
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
      },
    );
  }
}
