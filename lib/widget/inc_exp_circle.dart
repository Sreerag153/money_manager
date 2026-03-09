import 'package:flutter/material.dart';

class CircularTile extends StatelessWidget {
  final String title;
  final double value;
  final double percent;
  final Color color;

  const CircularTile({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: percent),
          duration: const Duration(milliseconds: 2000),
          curve: Curves.easeOut,
          builder: (context, animatedPercent, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: animatedPercent,
                    strokeWidth: 10,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '₹ ${value.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(percent * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}