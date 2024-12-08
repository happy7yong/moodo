import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodo/component/calendarGrid.dart';
import 'package:moodo/component/flowerPotImage.dart';
import 'package:moodo/main.dart';
import 'package:moodo/screen/diaryPage.dart';
import 'package:moodo/screen/loginPage.dart';
import 'package:moodo/service/auth_service.dart';

import 'package:provider/provider.dart';

/// 홈페이지
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();

  int? _currentMonth;
  final bool _isHovered = false;

//처음 시작할때 로딩
  @override
  void initState() {
    super.initState();
    _fetchCurrentMonth();
  }

//현재 달력 가져오기
  void _fetchCurrentMonth() {
    DateTime now = DateTime.now();
    _currentMonth = now.month; // 현재 월 값을 저장
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      User? user = authService.currentUser();
      return Scaffold(
        backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.calendar_today_rounded,
                    color: Colors.black),
                onPressed: () async {
                  final selectedMonth = await showDialog<int>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text("월 선택"),
                        content: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              12,
                              (index) {
                                final month = index + 1;
                                return ListTile(
                                  title: Text("${2024}년 $month월"),
                                  onTap: () {
                                    Navigator.of(context)
                                        .pop(month); // 선택한 월 반환
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  if (selectedMonth != null) {
                    // Update the state with the selected month
                    setState(() {
                      _currentMonth = selectedMonth;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '${_currentMonth?.toString().padLeft(2, '0') ?? '로딩 중'}월',
                  style: const TextStyle(fontSize: 26),
                ),

                const SizedBox(height: 70), // Text와 Row 사이의 간격 추가
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (var day in ['일', '월', '화', '수', '목', '금', '토'])
                      SizedBox(
                        width: 40,
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(96, 96, 96, 1)),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: CalendarGrid(
                    currentMonth: _currentMonth,
                    moodData: {},
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 20.0,
              left: 50.0,
              child: SizedBox(
                width: 130,
                height: 130,
                child: FlowerpotImage(
                  selectedMonth: _currentMonth!,
                ),
              ),
            ),
            Positioned(
              bottom: 30.0,
              right: 30.0,
              child: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    final today = DateTime.now();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Diarypage(
                          selectedDate: today,
                        ),
                      ),
                    );
                  },
                  elevation: 0,
                  backgroundColor: const Color.fromRGBO(53, 47, 47, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
