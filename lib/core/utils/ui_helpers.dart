import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class UiHelpers {
  UiHelpers._();

  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String formatCurrency(double amount) {
    return _currencyFormatter.format(amount);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dateTime);
  }

  static void showSnackBar(
    BuildContext context, {
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.cardElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isError ? AppColors.error : AppColors.border,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
      ),
    );
  }

  /// Creates a custom high-res Car icon bitmap for Google Maps marker
  static Future<BitmapDescriptor> createCarMarkerIcon({
    Color color = AppColors.primary,
    double size = 56.0,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double radius = size / 2;

    // Glowing outer circle
    final Paint glowPaint = Paint()
      ..color = color.withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius, glowPaint);

    // Dark base circle
    final Paint basePaint = Paint()
      ..color = AppColors.black
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius * 0.78, basePaint);

    // Border ring
    final Paint ringPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;
    canvas.drawCircle(Offset(radius, radius), radius * 0.78, ringPaint);

    // Car icon in the center
    final TextPainter textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(Icons.directions_car_rounded.codePoint),
      style: TextStyle(
        fontSize: size * 0.44,
        fontFamily: Icons.directions_car_rounded.fontFamily,
        package: Icons.directions_car_rounded.fontPackage,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - (textPainter.width / 2), radius - (textPainter.height / 2)),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(
          size.toInt(),
          size.toInt(),
        );
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }

  /// Creates a custom high-res Pickup / Drop Pin marker icon
  static Future<BitmapDescriptor> createPinMarkerIcon({
    required Color color,
    required IconData iconData,
    double size = 46.0,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double radius = size / 2;

    // Outer glow
    final Paint glowPaint = Paint()
      ..color = color.withValues(alpha: 0.30)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius, glowPaint);

    // Main filled circle
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(radius, radius), radius * 0.76, fillPaint);

    // Crisp white border
    final Paint borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(Offset(radius, radius), radius * 0.76, borderPaint);

    // Icon text in crisp white
    final TextPainter textPainter = TextPainter(textDirection: ui.TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size * 0.42,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(radius - (textPainter.width / 2), radius - (textPainter.height / 2)),
    );

    final ui.Image image = await pictureRecorder.endRecording().toImage(
          size.toInt(),
          size.toInt(),
        );
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }
}
