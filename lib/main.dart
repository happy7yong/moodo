import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                      'assets/images/moodo-logo.png', // 이미지 경로
                      width: 120, // 이미지의 너비
                      height: 120, // 이미지의 높이
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
  bool _isHovered = false;

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
              padding: const EdgeInsets.all(35.0),
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
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 30.0, right: 10),
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHovered = true; // 마우스가 버튼 위에 있을 때
                });
              },
              onExit: (_) {
                setState(() {
                  _isHovered = false; // 마우스가 버튼을 떠날 때
                });
              },
              child: SizedBox(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Diarypage()),
                    );
                  },
                  elevation: _isHovered ? 0 : 0,
                  backgroundColor: const Color.fromRGBO(53, 47, 47, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ));
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
    final lastDayOfMonth = DateTime(now.year, currentMonth! + 1, 0);
    final daysInMonth = lastDayOfMonth.day;

    final startWeekday = firstDayOfMonth.weekday % 7; // 0(일요일) ~ 6(토요일)

    const totalCells = 7 * 5; // 7열 5행
    final calendarDays = List<String?>.filled(totalCells, null);

    // 날짜를 채우기
    for (int day = 1; day <= daysInMonth; day++) {
      calendarDays[startWeekday + day - 1] = day.toString();
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7, // 7열
        childAspectRatio: 1.0, // 정사각형 형태
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(4.0),
          child: Center(
            child: Text(
              calendarDays[index] ?? '',
              style: const TextStyle(
                fontSize: 17,
              ),
            ),
          ),
        );
      },
    );
  }
}
