import 'package:flutter/material.dart';

class MyClipperForShadow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height), radius: 12.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height), radius: 12.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(center: Offset(0.0, size.height), radius: 12.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, size.height), radius: 12.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(center: Offset(0.0, 0.0), radius: 12.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, 0.0), radius: 12.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper2ForShadow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(center: Offset(0.0, 0.0), radius: 12.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width, 0.0), radius: 12.0));

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BoxShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height - 10);
    path.lineTo(size.width + 10, size.height - 10);
    path.lineTo(size.width, 0.0);
    path.addOval(Rect.fromCircle(center: Offset(421, size.height), radius: 40.0));
    path.addOval(Rect.fromCircle(center: Offset(size.width - 1242, size.height), radius: 40.0));

    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 5.0, true);
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = false
      ..strokeWidth = 4.0
      ..color = Colors.grey.withOpacity(0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class BoxShadowPainter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.addOval(Rect.fromCircle(center: Offset(1.0, 3.0), radius: 20.0));
    path.lineTo(0.0 + 10, size.height + 10);
    path.lineTo(size.width + 10, size.height + 10);
    path.lineTo(size.width + 10, 0.0);

    path.addOval(Rect.fromCircle(center: Offset(size.width, 0.0), radius: 20.0));
    canvas.drawShadow(path, Colors.black.withOpacity(0.1), 1.0, false);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = 1.0
      ..color = Colors.grey.withOpacity(0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ClipOvalShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.addArc(Rect.fromCircle(center: Offset(1, size.height), radius: 15), size.width - 1, 28);
    // path.addArc(Rect.fromCircle(center: Offset(1, size.height), radius: 15), size.width - 1, 28);
    path.conicTo(size.width - 10, size.height, size.width, 0, 22);

    // path.addOval(Rect.fromCircle(center: Offset(1.0, size.height), radius: 15.0));
    // path.addOval(Rect.fromCircle(center: Offset(size.width, size.height), radius: 15.0));
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.black;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
