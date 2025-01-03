import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:moodo/service/auth_service.dart';
import 'package:moodo/component/moodSelector.dart';
import 'package:moodo/component/sentiment_Analyzer.dart';
import 'package:moodo/service/diary_service.dart';
import 'package:provider/provider.dart';
import 'package:dart_sentiment/dart_sentiment.dart';

class Diarypage extends StatefulWidget {
  final DateTime selectedDate;

  const Diarypage({
    super.key,
    required this.selectedDate,
  });

  @override
  _DiarypageState createState() => _DiarypageState();
}

class _DiarypageState extends State<Diarypage> {
  final TextEditingController DiaryCollection = TextEditingController();
  String _selectedMood = 'default';
  String sentiment = "";
  String? selectedDocId;
  Map<int, String> moodData = {};

  // 감정과 이미지 파일 연결
  final Map<String, String> moodImages = {
    'positive': 'assets/images/moodEmoji/positiveMood.png',
    'neutral': 'assets/images/moodEmoji/neutralityMood.png',
    'negative': 'assets/images/moodEmoji/negativeMood.png',
    'default': 'assets/images/moodEmoji/defaultMood.png',
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    String? currentDocId;
    final formattedDate =
        "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";

    String getDayOfWeek(DateTime date) {
      const daysOfWeek = [
        '월',
        '화',
        '수',
        '목',
        '금',
        '토',
        '일',
      ];
      return daysOfWeek[date.weekday - 1];
    }

    return Consumer<DiaryService>(
      builder: (context, DiaryService, child) {
        return Scaffold(
          backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
            //뒤로가기 버튼
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
          ),
          body: Center(
            child: FutureBuilder<bool>(
              future: DiaryService.hasDiary(user.uid, formattedDate),
              builder: (context, snapshot) {
                //해당 날짜에 데이터가 있을 경우 반환하기
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('데이터를 불러오는 중 문제가 발생했습니다.'));
                } else {
                  final hasData = snapshot.data ?? false;

                  return Column(
                    children: [
                      FutureBuilder<QuerySnapshot>(
                          future: DiaryService.read(user.uid),
                          builder: (context, snapshot) {
                            final documents = snapshot.data?.docs ?? [];

                            // 날짜별 moodData 맵 생성
                            final Map<int, String> moodData = {};
                            final now = DateTime.now();
                            for (var doc in documents) {
                              final data = doc.data() as Map<String, dynamic>;
                              if (data['date'] != null &&
                                  data['mood'] != null) {
                                // Firebase에 저장된 날짜를 파싱하여 일(day)만 추출
                                final dateParts = data['date'].split('-');
                                if (dateParts.length == 3 &&
                                    int.tryParse(dateParts[0]) == now.year &&
                                    int.tryParse(dateParts[1]) == now.month) {
                                  final day = int.tryParse(dateParts[2]);
                                  if (day != null) {
                                    moodData[day] = data['mood'];
                                  }
                                }
                              }
                            }
                            // 오늘 날짜의 mood 초기화
                            for (var doc in documents) {
                              final data = doc.data() as Map<String, dynamic>;
                              if (data['date'] != null &&
                                  data['mood'] != null) {
                                final dateParts = data['date'].split('-');
                                if (dateParts.length == 3 &&
                                    int.tryParse(dateParts[0]) == now.year &&
                                    int.tryParse(dateParts[1]) == now.month) {
                                  final day = int.tryParse(dateParts[2]);
                                  if (day != null) {
                                    moodData[day] = data['mood'];
                                  }
                                }
                              }

                              if (data['date'] == formattedDate) {
                                _selectedMood = data['mood'] ?? 'default';
                                currentDocId = doc.id;
                                break;
                              }
                            }

                            print(
                                "Selected mood for $formattedDate: $_selectedMood");

                            if (currentDocId == null) {
                              return Center(
                                child: Image.asset(
                                    'assets/images/moodEmoji/defaultMood.png'),
                              );
                            }

                            return GestureDetector(
                              onTap: () {
                                print('버튼이 클릭되었습니다!');

                                showModalBottomSheet(
                                  backgroundColor:
                                      Color.fromRGBO(251, 250, 248, 1),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MoodSelector(
                                      onMoodSelected: (moodEmoji) {
                                        setState(() {
                                          _selectedMood = moodEmoji;
                                        });
                                      },
                                      currentDocId: currentDocId!,
                                    );
                                  },
                                );
                              },
                              child: Image.asset(
                                moodImages[_selectedMood]!,
                                width: 90,
                                height: 90,
                              ),
                            );
                          }),
                      const SizedBox(height: 10),
                      if (currentDocId != null)
                        FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('Diary')
                                .doc(currentDocId)
                                .get(),
                            builder: (context, snapshot) {
                              String moodData =
                                  snapshot.data?.get('mood') ?? 'default';
                              bool isExistingEntry = moodData == 'positive' ||
                                  moodData == 'neutral' ||
                                  moodData == 'negative';

                              return Column(
                                children: [
                                  if (isExistingEntry)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/images/mentStar.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        Text(
                                          moodData == 'positive'
                                              ? '기분 좋은 하루셨군요!'
                                              : moodData == 'neutral'
                                                  ? '평온한 하루는 때때로 가장 특별한 순간이죠.'
                                                  : '힘든 하루를 보내셨군요.',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 189, 98, 1)),
                                        ),
                                      ],
                                    ),
                                  if (!isExistingEntry)
                                    Container(
                                      width: 300,
                                      height: 70,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color.fromRGBO(
                                              255, 221, 173, 1),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '오늘의 일기를 모두 기록하면',
                                            style: TextStyle(
                                                fontSize: 18, height: 1.1),
                                          ),
                                          Text(
                                            '오늘의 감정 이모티콘이 생겨요!',
                                            style: TextStyle(
                                                fontSize: 18, height: 1.1),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              );
                            }),
                      const SizedBox(height: 15),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${widget.selectedDate.year}년 ${widget.selectedDate.month}월 ${widget.selectedDate.day}일",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${getDayOfWeek(widget.selectedDate)}요일',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: FutureBuilder<QuerySnapshot>(
                            future: DiaryService.read(user.uid),
                            builder: (context, snapshot) {
                              final documents = snapshot.data?.docs ?? [];
                              String initialText = '';
                              bool isExistingEntry = false;
                              final todayString =
                                  "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";
                              for (var doc in documents) {
                                final data = doc.data() as Map<String, dynamic>;
                                if (data['date'] == todayString) {
                                  initialText = data['content'] ?? '';
                                  isExistingEntry = true;
                                  break;
                                }
                              }
                              DiaryCollection.text = initialText;
                              return TextField(
                                controller: DiaryCollection,
                                decoration: const InputDecoration(
                                  hintText: "오늘은 어떤 하루를 보내셨나요?",
                                  hintStyle: TextStyle(
                                    color: Color.fromRGBO(212, 212, 212, 1),
                                    fontSize: 18,
                                  ),
                                  border: InputBorder.none,
                                ),
                                maxLines: null,
                              );
                            },
                          ),
                        ),
                      ),
                      if (!hasData)
                        ElevatedButton(
                          onPressed: () async {
                            final formattedDate =
                                "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    height: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 14),
                                        Image.asset(
                                          'assets/images/diaryIcon.png',
                                          width: 130,
                                          height: 130,
                                        ),
                                        const SizedBox(height: 20),
                                        const Text(
                                          '오늘의 기록을 모두 작성하셨나요?',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        const SizedBox(height: 13),
                                        const SizedBox(
                                          width: 230,
                                          child: Column(
                                            children: [
                                              Text(
                                                '현재 작성된 일기를 기반으로',
                                                style: TextStyle(
                                                    fontSize: 15, height: 1),
                                              ),
                                              Text(
                                                '감정 이모티콘을 추천해드릴게요!',
                                                style: TextStyle(
                                                    fontSize: 15, height: 1),
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
                                        onPressed: () async {
                                          // 분석할 텍스트를 정의
                                          String textToAnalyze =
                                              DiaryCollection.text;
                                          String sentimentKeyword =
                                              await analyzeKoreanSentiment(
                                                  textToAnalyze);

                                          // 선택된 기분 업데이트
                                          setState(() {
                                            _selectedMood = sentimentKeyword;
                                          });

                                          final formattedDate =
                                              "${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day}";
                                          DiaryService.create(
                                              formattedDate,
                                              user.uid,
                                              DiaryCollection.text,
                                              sentimentKeyword);

                                          Navigator.of(context).pop();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromRGBO(
                                              255, 186, 101, 1),
                                          elevation: 0,
                                          minimumSize: const Size(130, 40),
                                        ),
                                        child: const Text(
                                          '감정 받기',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(53, 47, 47, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            minimumSize: const Size(120, 50),
                            elevation: 0,
                          ),
                          child: const Text(
                            '기록 완료',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      if (hasData)
                        SizedBox(
                          width: 30,
                          height: 30,
                          child: GestureDetector(
                            onTap: () {
                              DiaryService.update(
                                  currentDocId, DiaryCollection.text);
                            },
                            child: Image.asset(
                              'assets/images/updataIcon.png',
                            ),
                          ),
                        ),
                      const SizedBox(height: 20)
                    ],
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
