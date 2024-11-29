import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodo/firebase_options.dart';
import 'auth_service.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(builder: (context, authService, child) {
      User? user = authService.currentUser();
      return Scaffold(
        backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(251, 250, 248, 1),
          title: const Text("버킷 리스트"),
          actions: [
            TextButton(
              child: const Text("로그아웃"),
              onPressed: () {
                context.read<AuthService>().signOut();
                // 로그인 페이지로 이동
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            /// 입력창
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(children: [
                Text("${user?.email}", style: const TextStyle(fontSize: 16)),
              ]),
            ),
          ],
        ),
      );
    });
  }
}
