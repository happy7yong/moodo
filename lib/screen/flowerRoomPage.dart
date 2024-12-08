import 'package:flutter/material.dart';

class FlowerRoom extends StatelessWidget {
  const FlowerRoom({super.key});

  @override
  Widget build(BuildContext context) {
    //final authService = context.read<AuthService>();
    //final user = authService.currentUser()!;
    Color:
    Color.fromRGBO(251, 250, 248, 1);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 30,
        ),
        Text('11월의 꽃은', style: TextStyle()),
        Image.asset('', width: 100, height: 100),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
