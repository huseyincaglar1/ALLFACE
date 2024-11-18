import 'package:flutter/material.dart';
import 'dart:math' as math;

class Circular_arc extends StatefulWidget {
  const Circular_arc ({super.key, required this.progress});
  final double progress;
  @override
  _Circular_arcState createState() => _Circular_arcState();
}

class _Circular_arcState extends State<Circular_arc>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    animController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    final curveAnimation =
        CurvedAnimation(parent: animController, curve: Curves.easeInOutCubic);
    animation = Tween<double>(begin: 0.0, end: 3.14).animate(curveAnimation)
      ..addListener(() {
        setState(() {});
      });
    animController.repeat(reverse: false);
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Stack(children: [
          CustomPaint(
            size: const Size(150, 150),
            painter: ProgressArc(0, Colors.black54, true),
          ),
          CustomPaint(
            size: const Size(150, 150),
            painter: ProgressArc(widget.progress * math.pi, Colors.redAccent, false),
          ),
          Positioned(
            top: 75,
            left: 80,
            child: Text(
              "${(widget.progress * 100).round()}%",
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),
          )
        ]),
      ),
    );
  }
}

final Gradient gradient = LinearGradient(colors: <Color>[
  Colors.greenAccent.withOpacity(1.0),
  Colors.yellowAccent.withOpacity(1.0),
  Colors.redAccent.withOpacity(1.0),
], stops: const [
  0.0,
  0.5,
  1.0,
]);

class ProgressArc extends CustomPainter {
  bool isBackground;
  double arc;
  Color progressColor;

  ProgressArc(this.arc, this.progressColor, this.isBackground);

  @override
  void paint(Canvas canvas, Size size) {
    const rect = Rect.fromLTRB(0, 0, 200, 200);
    const startAngle = -math.pi;
    final sweetAngle = arc ?? math.pi;
    const userCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;
    if (!isBackground) {
      paint.shader = gradient.createShader(rect);
    }
    canvas.drawArc(rect, startAngle, sweetAngle, userCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
