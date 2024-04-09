import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_app/task_list_screen.dart';
import 'package:to_do_app/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => TaskListScreen()));
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tgbackground,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 85, top: 250),
              child: Lottie.network(
                  'https://lottie.host/94a0a083-68aa-46d3-b4c0-a717e2b71650/0EKgN8R0Ju.json'),
            ),
            Text(
              "To-Do App",
              style: GoogleFonts.jost(
                  color: tgpurple, fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
