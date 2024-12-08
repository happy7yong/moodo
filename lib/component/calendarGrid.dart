import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moodo/screen/diaryPage.dart';
import 'package:moodo/service/auth_service.dart';
import 'package:moodo/service/diary_service.dart';
import 'package:provider/provider.dart';

class CalendarGrid extends StatelessWidget {
  final int? currentMonth;
  final Map<int, String> moodData;

  const CalendarGrid({
    super.key,
    this.currentMonth,
    required this.moodData,
  });

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, currentMonth ?? now.month, 1);
    final lastDayOfMonth = DateTime(
      now.year,
      (currentMonth ?? now.month) + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    const totalCells = 7 * 6;
    final calendarDays = List<DateTime?>.filled(totalCells, null);

    final Map<String, String> moodImages = {
      'positive': 'assets/images/moodEmoji/positiveMood.png',
      'neutral': 'assets/images/moodEmoji/neutralityMood.png',
      'negative': 'assets/images/moodEmoji/negativeMood.png',
      'default': 'assets/images/moodEmoji/defaultMood.png',
    };

    for (int day = 1; day <= daysInMonth; day++) {
      calendarDays[startWeekday + day - 1] =
          DateTime(firstDayOfMonth.year, firstDayOfMonth.month, day);
    }

    return Consumer<DiaryService>(
      builder: (context, diaryService, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: diaryService.stream(user.uid),
          builder: (context, snapshot) {
            final documents = snapshot.data?.docs ?? [];
            final Map<DateTime, String> fetchedMoodData = {};

            for (var doc in documents) {
              final data = doc.data() as Map<String, dynamic>;
              final date = data['date']?.split('-');

              if (date != null && date.length == 3) {
                final year = int.tryParse(date[0]);
                final month = int.tryParse(date[1]);
                final day = int.tryParse(date[2]);

                if (year != null && month != null && day != null) {
                  final mood = data['mood'] ?? 'default';
                  final dateKey = DateTime(year, month, day);
                  fetchedMoodData[dateKey] = mood;
                }
              }
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: totalCells,
              itemBuilder: (context, index) {
                final cellDate = calendarDays[index];
                if (cellDate == null) return Container();

                final mood = fetchedMoodData[cellDate];

                final isToday =
                    cellDate == DateTime(now.year, now.month, now.day);
                final isPast =
                    cellDate.isBefore(DateTime(now.year, now.month, now.day));
                final isFuture =
                    cellDate.isAfter(DateTime(now.year, now.month, now.day));

                return Container(
                  margin: const EdgeInsets.all(4.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: TextButton(
                              onPressed: isFuture
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Diarypage(
                                            selectedDate: cellDate,
                                          ),
                                        ),
                                      );
                                    },
                              style: TextButton.styleFrom(
                                backgroundColor: isToday
                                    ? const Color.fromRGBO(255, 240, 223, 1)
                                    : null,
                                shape: const CircleBorder(),
                              ),
                              child: Center(
                                child: mood != null
                                    ? Image.asset(
                                        moodImages[mood]!,
                                        width: 40,
                                        height: 40,
                                      )
                                    : Text(
                                        cellDate.day.toString(),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: isToday
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          color: isToday
                                              ? const Color.fromRGBO(
                                                  255, 169, 49, 1)
                                              : isPast
                                                  ? Colors.black
                                                  : Colors.grey,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
