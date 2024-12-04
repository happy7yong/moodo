import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moodo/diary_service.dart';
import 'package:moodo/firebase_options.dart';
import 'auth_service.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'diaryPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => DiaryService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'leeseoyun',
      ),
      home: user == null ? const LoginPage() : const HomePage(),
    );
  }
}

/// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser(); //뒤에 !를 붙이면 로그인 화면에서 오류가 나요.
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        User? user = authService.currentUser();
        return Scaffold(
          backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 현재 유저 로그인 상태
                  Center(
                    child: Image.asset(
                      'assets/images/moodo-logo.png',
                      width: 120,
                      height: 120,
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// 이메일
                  TextField(
                    textAlign: TextAlign.center,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "이메일",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(231, 225, 212, 1),
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(231, 225, 212, 1),
                              width: 1.5)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(231, 225, 212, 1),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(231, 225, 212, 1),
                          width: 1.5,
                        ),
                      ), // 기본 테두리
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// 비밀번호
                  TextField(
                    textAlign: TextAlign.center,
                    controller: passwordController,
                    obscureText: false, // 비밀번호 안보이게
                    decoration: InputDecoration(
                      hintText: "비밀번호",
                      hintStyle: const TextStyle(
                        color: Color.fromRGBO(231, 225, 212, 1),
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(13),
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(231, 225, 212, 1),
                              width: 1.5)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(231, 225, 212, 1),
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(13),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(231, 225, 212, 1),
                          width: 1.5,
                        ),
                      ), // 기본 테두리
                    ),
                  ),
                  const SizedBox(height: 32),

                  /// 로그인 버튼
                  TextButton(
                    onPressed: () {
                      // 로그인
                      authService.signIn(
                        email: emailController.text,
                        password: passwordController.text,
                        onSuccess: () {
                          // 로그인 성공
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("로그인 성공"),
                          ));

                          // HomePage로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                          );
                        },
                        onError: (err) {
                          // 에러 발생
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(98, 73, 73, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    child: const Text(
                      "로그인",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// 회원가입 버튼
                  TextButton(
                    onPressed: () {
                      // 회원가입
                      authService.signUp(
                        email: emailController.text,
                        password: passwordController.text,
                        onSuccess: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("회원가입 성공"),
                          ));
                        },
                        onError: (err) {
                          // 에러 발생
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err),
                          ));
                        },
                      );
                    },
                    style: TextButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromRGBO(98, 73, 73, 1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                      minimumSize: const Size(double.infinity, 55),
                    ),
                    child: const Text(
                      "회원가입",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(98, 73, 73, 1)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 홈페이지
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();
  final String _currentDate = '';
  int? _currentMonth;
  final bool _isHovered = false;

//처음 시작할때 로딩
  @override
  void initState() {
    super.initState();
    _fetchCurrentMonth(); // 월 값을 가져오는 함수 호출
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
          leading: IconButton(
              onPressed: () {
                context.read<AuthService>().signOut();
                // 로그인 페이지로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              icon: const Icon(
                Icons.logout_rounded,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.calendar_today_rounded,
                    color: Colors.black),
                onPressed: () {},
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
                const SizedBox(height: 20), // Row와 GridView 사이의 간격 추가
                Expanded(
                  child: CalendarGrid(currentMonth: _currentMonth),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 30.0,
              left: 50.0,
              child: SizedBox(
                width: 80,
                height: 80,
                child: GestureDetector(
                    onTap: () {
                      print("화분이 클릭되었습니다!");
                    },
                    child: Image.asset(
                      'assets/images/flowerpot.png',
                      width: 100,
                      height: 100,
                    )),
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

class CalendarGrid extends StatelessWidget {
  final int? currentMonth;

  const CalendarGrid({super.key, this.currentMonth});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, currentMonth ?? now.month, 1);
    final lastDayOfMonth = DateTime(
      now.year,
      (currentMonth ?? now.month) + 1,
      0,
    );
    final daysInMonth = lastDayOfMonth.day; //월에 포함된 총 날짜 수

    final startWeekday = firstDayOfMonth.weekday % 7; // 0(일요일) ~ 6(토요일)

    const totalCells = 7 * 5; // 7열 5행
    final calendarDays = List<int?>.filled(totalCells, null);

    // 날짜를 채우기
    for (int day = 1; day <= daysInMonth; day++) {
      calendarDays[startWeekday + day - 1] = day;
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7열
        childAspectRatio: 1.0, // 정사각형 형태
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final day = calendarDays[index];
        // 오늘
        final isToday = day != null &&
            now.year == firstDayOfMonth.year &&
            now.month == firstDayOfMonth.month &&
            day == now.day;
        // 과거 오늘 이전
        final isPast = day != null && day < now.day;
        // 미래 오늘 이후
        final isFuture = day != null && day > now.day;

        return Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: isToday ? const Color.fromRGBO(255, 240, 223, 1) : null,
            borderRadius: BorderRadius.circular(40.0),
          ),
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: TextButton(
                onPressed: isFuture
                    ? null
                    : () {
                        final selectedDate = DateTime(
                          firstDayOfMonth.year,
                          firstDayOfMonth.month,
                          day!,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Diarypage(
                              selectedDate: selectedDate,
                            ),
                          ),
                        );
                      },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent, // 기본 배경색을 투명으로 설정
                ),
                child: Text(
                  day?.toString() ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                    color: isToday
                        ? const Color.fromRGBO(255, 169, 49, 1)
                        : isPast
                            ? Colors.black
                            : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
