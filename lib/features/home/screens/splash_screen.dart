import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utils/constants/assets.dart';
import '../../../utils/constants/colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..forward();

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, animation, __) =>
                FadeTransition(opacity: animation, child: const HomeScreen()),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: Center(
      child: ScaleTransition(
        scale: CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
        child: Image.asset(AppAssets.logo, width: 210),
      ),
    ),
  );
}
