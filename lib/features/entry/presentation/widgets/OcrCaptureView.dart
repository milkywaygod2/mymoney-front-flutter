import 'package:flutter/material.dart';

import '../../../../app/theme/AppColors.dart';

/// V3 카메라 프리뷰 — camera 패키지 연동 전 stub UI
class OcrCaptureView extends StatelessWidget {
  const OcrCaptureView({
    super.key,
    required this.onCapture,
  });

  final VoidCallback onCapture;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.darkBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 카메라 프리뷰 프레임 (stub)
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 64,
                      color: Colors.white54,
                    ),
                    SizedBox(height: 12),
                    Text(
                      '영수증을 프레임 안에 맞춰주세요',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '(카메라 권한 허용 후 활성화됩니다)',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                  ],
                ),
                // 가이드 프레임
                Positioned.fill(
                  child: CustomPaint(painter: _FrameGuide()),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: FilledButton.icon(
            onPressed: onCapture,
            icon: const Icon(Icons.camera),
            label: const Text('촬영'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}

/// 영수증 가이드 프레임 CustomPainter
class _FrameGuide extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white38
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const margin = 32.0;
    const cornerLen = 20.0;
    final left = margin;
    final top = margin;
    final right = size.width - margin;
    final bottom = size.height - margin;

    // 모서리 4개
    // 좌상
    canvas.drawLine(Offset(left, top + cornerLen), Offset(left, top), paint);
    canvas.drawLine(Offset(left, top), Offset(left + cornerLen, top), paint);
    // 우상
    canvas.drawLine(Offset(right - cornerLen, top), Offset(right, top), paint);
    canvas.drawLine(Offset(right, top), Offset(right, top + cornerLen), paint);
    // 좌하
    canvas.drawLine(Offset(left, bottom - cornerLen), Offset(left, bottom), paint);
    canvas.drawLine(Offset(left, bottom), Offset(left + cornerLen, bottom), paint);
    // 우하
    canvas.drawLine(Offset(right - cornerLen, bottom), Offset(right, bottom), paint);
    canvas.drawLine(Offset(right, bottom), Offset(right, bottom - cornerLen), paint);
  }

  @override
  bool shouldRepaint(_FrameGuide _) => false;
}
