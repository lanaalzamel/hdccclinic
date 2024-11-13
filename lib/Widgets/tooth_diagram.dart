// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// class ToothDiagram extends StatefulWidget {
//   @override
//   _ToothDiagramState createState() => _ToothDiagramState();
// }
//
// class _ToothDiagramState extends State<ToothDiagram> {
//   String _targetToothId = "tooth1"; // Default target tooth ID
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<PictureInfo>(
//       future: _loadSvgAsset('assets/Human_dental_arches.svg'),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator();
//         }
//         return CustomPaint(
//           size: Size(300, 300),
//           painter: ToothPainter(snapshot.data!, _targetToothId),
//         );
//       },
//     );
//   }
//
//   Future<PictureInfo> _loadSvgAsset(String assetName) async {
//     final DrawableRoot svgRoot = await svg.fromSvgString(
//       await DefaultAssetBundle.of(context).loadString(assetName),
//       assetName,
//     );
//     return svgRoot.toPicture();
//   }
// }
//
// class ToothPainter extends CustomPainter {
//   final PictureInfo pictureInfo;
//   final String targetToothId;
//
//   ToothPainter(this.pictureInfo, this.targetToothId);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint defaultPaint = Paint();
//     final Paint highlightPaint = Paint()..color = Colors.red; // Highlight color
//
//     // Draw the entire SVG picture
//     canvas.drawPicture(pictureInfo.picture);
//
//     // Iterate over each child drawable in the SVG (this is pseudo-code, just for concept)
//     for (final Drawable child in pictureInfo.drawable.children) {
//       if (child.id == targetToothId) {
//         // Repaint the targeted tooth with a different color
//         child.draw(canvas, highlightPaint);
//       } else {
//         child.draw(canvas, defaultPaint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
//
