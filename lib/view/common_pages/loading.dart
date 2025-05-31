import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _iconController;

  @override
  void initState() {
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Continuous rotation
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Setting things up for you ',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color.fromARGB(229, 0, 31, 86),
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                ),
                AnimatedBuilder(
                  animation: _iconController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _iconController.value * 2 * math.pi,
                      child: child,
                    );
                  },
                  child: const Icon(
                    Icons.sync,
                    size: 26,
                    color: Color.fromARGB(255, 110, 9, 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Lottie.asset(
              'assets/lotties/loading.json',
              fit: BoxFit.fitWidth,
              width: double.infinity,
            ),
            const SizedBox(height: 30),
            const Text(
              'We are fetching data from the server...\nThis won’t take long.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            LinearProgressIndicator(
              minHeight: 4,
              backgroundColor: Colors.grey.shade300,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
