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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
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
        return Scaffold(
          appBar: AppBar(title: const Text("로그인")),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// 현재 유저 로그인 상태
                const Center(
                  child: Text(
                    "로그인해 주세요 🙂",
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                /// 이메일
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "이메일"),
                ),

                /// 비밀번호
                TextField(
                  controller: passwordController,
                  obscureText: false, // 비밀번호 안보이게
                  decoration: const InputDecoration(hintText: "비밀번호"),
                ),
                const SizedBox(height: 32),

                /// 로그인 버튼
                ElevatedButton(
                  child: const Text("로그인", style: TextStyle(fontSize: 21)),
                  onPressed: () {
                    // 로그인 성공시 HomePage로 이동
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                    );
                  },
                ),

                /// 회원가입 버튼
                ElevatedButton(
                  child: const Text("회원가입", style: TextStyle(fontSize: 21)),
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
                ),
              ],
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("버킷 리스트"),
        actions: [
          TextButton(
            child: const Text("로그아웃"),
            onPressed: () {
              print("sign out");
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
            child: Row(
              children: [
                /// 텍스트 입력창
                Expanded(
                  child: TextField(
                    controller: jobController,
                    decoration: const InputDecoration(
                      hintText: "하고 싶은 일을 입력해주세요.",
                    ),
                  ),
                ),

                /// 추가 버튼
                ElevatedButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    // create bucket
                    if (jobController.text.isNotEmpty) {
                      print("create bucket");
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          /// 버킷 리스트
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                String job = "$index";
                bool isDone = false;
                return ListTile(
                  title: Text(
                    job,
                    style: TextStyle(
                      fontSize: 24,
                      color: isDone ? Colors.grey : Colors.black,
                      decoration: isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  // 삭제 아이콘 버튼
                  trailing: IconButton(
                    icon: const Icon(CupertinoIcons.delete),
                    onPressed: () {
                      // 삭제 버튼 클릭시
                    },
                  ),
                  onTap: () {
                    // 아이템 클릭하여 isDone 업데이트
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
