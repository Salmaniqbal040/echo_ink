import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../journal/screens/journal_screen.dart';
import '../../recording/screens/recording_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.auto_stories_rounded, color: AppColors.primary),
                Text('Home', style: TextStyle(fontWeight: FontWeight.w700)),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.person,
                    size: 17,
                    color: AppColors.background,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  'Good Evening, Alex',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                ),
                const SizedBox(height: 8),
                const Text(
                  'MONDAY, AUG 17',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 34),
                const _PulsingRecordButton(),
                const SizedBox(height: 30),
                Container(
                  height: 3,
                  width: 160,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Tap to record your thoughts, feelings,\nand daily routine.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            _BottomNavigation(
              onLibrary: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const JournalScreen()),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PulsingRecordButton extends StatefulWidget {
  const _PulsingRecordButton();

  @override
  State<_PulsingRecordButton> createState() => _PulsingRecordButtonState();
}

class _PulsingRecordButtonState extends State<_PulsingRecordButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (_, __) => Transform.scale(
      scale: 1 + _controller.value * .05,
      child: InkWell(
        borderRadius: BorderRadius.circular(80),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RecordingScreen()),
        ),
        child: Container(
          height: 124,
          width: 124,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceElevated,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.2),
                blurRadius: 28,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.mic_none_rounded,
            size: 38,
            color: AppColors.primaryLight,
          ),
        ),
      ),
    ),
  );
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({required this.onLibrary});

  final VoidCallback onLibrary;

  @override
  Widget build(BuildContext context) => Container(
    height: 72,
    decoration: const BoxDecoration(
      border: Border(top: BorderSide(color: AppColors.divider)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const _NavItem(icon: Icons.mic_rounded, label: 'Echo', active: true),
        GestureDetector(
          onTap: onLibrary,
          child: const _NavItem(
            icon: Icons.auto_stories_outlined,
            label: 'Library',
          ),
        ),
        const _NavItem(icon: Icons.settings_outlined, label: 'Settings'),
      ],
    ),
  );
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon,
        size: 19,
        color: active ? AppColors.primaryLight : AppColors.textSecondary,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: active ? AppColors.primaryLight : AppColors.textSecondary,
        ),
      ),
    ],
  );
}
