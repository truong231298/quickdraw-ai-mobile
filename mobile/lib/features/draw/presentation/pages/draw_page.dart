import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../data/draw_api_service.dart';

import '../painters/drawing_painter.dart';

class DrawPage extends StatefulWidget {

  const DrawPage({super.key});

  @override
  State<DrawPage> createState() =>
      _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {

  final GlobalKey canvasKey = GlobalKey();
  final GlobalKey drawingKey = GlobalKey();

  final DrawApiService apiService =
  DrawApiService();

  List<Offset?> points = [];

  String prediction = "";
  double confidence = 0;

  bool isLoading = false;

  Future<Uint8List?> exportCanvas() async {

    try {

      RenderRepaintBoundary boundary =
      canvasKey.currentContext!
          .findRenderObject()
      as RenderRepaintBoundary;

      ui.Image image =
      await boundary.toImage(
        pixelRatio: 3.0,
      );

      ByteData? byteData =
      await image.toByteData(
        format:
        ui.ImageByteFormat.png,
      );

      return byteData?.buffer
          .asUint8List();

    } catch (e) {

      debugPrint(
        e.toString(),
      );

      return null;
    }
  }

  Future<void> predictDrawing() async {

    try {

      setState(() {
        isLoading = true;
      });

      Uint8List? imageBytes =
      await exportCanvas();

      if (imageBytes == null) {

        setState(() {
          isLoading = false;
        });

        return;
      }

      final result =
      await apiService
          .predictDrawing(
        imageBytes,
      );

      if (result != null) {

        setState(() {

          prediction =
          result['prediction'];

          confidence =
          result['confidence'];

          isLoading = false;
        });

      } else {

        setState(() {
          isLoading = false;
        });
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      debugPrint(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "QuickDraw AI",
        ),
      ),

      body: Column(

        children: [

          Expanded(

            child: GestureDetector(

              key: drawingKey,

              onPanUpdate: (details) {

                setState(() {

                  RenderBox renderBox =

                  drawingKey
                      .currentContext!
                      .findRenderObject()

                  as RenderBox;

                  points.add(

                    renderBox.globalToLocal(
                      details.globalPosition,
                    ),
                  );
                });
              },

              onPanEnd: (_) {

                points.add(null);
              },

              child: RepaintBoundary(

                key: canvasKey,

                child: Container(

                  decoration:
                  BoxDecoration(

                    color: Colors.white,

                    border: Border.all(
                      color:
                      Colors.black12,
                    ),
                  ),

                  child: CustomPaint(

                    painter:
                    DrawingPainter(
                      points,
                    ),

                    child: Container(),
                  ),
                ),
              ),
            ),
          ),

          Padding(

            padding:
            const EdgeInsets.all(16),

            child: Column(

              children: [

                Row(

                  children: [

                    Expanded(

                      child:
                      ElevatedButton(

                        onPressed: () {

                          setState(() {

                            points.clear();

                            prediction = "";

                            confidence = 0;
                          });
                        },

                        child: const Text(
                          "Clear",
                        ),
                      ),
                    ),

                    const SizedBox(
                      width: 16,
                    ),

                    Expanded(

                      child:
                      ElevatedButton(

                        onPressed: () async {

                          await predictDrawing();
                        },

                        child: const Text(
                          "Predict",
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 24,
                ),

                isLoading

                    ? const CircularProgressIndicator(
                  strokeWidth: 6,
                )

                    : Column(

                  children: [

                    Text(

                      prediction.isEmpty

                          ? "Draw something"

                          : prediction,

                      style:
                      const TextStyle(

                        fontSize: 28,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    LinearProgressIndicator(

                      value: confidence,

                      minHeight: 10,
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(

                      "${(confidence * 100).toStringAsFixed(1)}% confidence",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}