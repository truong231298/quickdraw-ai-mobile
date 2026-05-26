import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

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

      ui.Image image = await boundary.toImage(
        pixelRatio: 3.0,
      );

      ByteData? byteData =
      await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      return byteData?.buffer.asUint8List();

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

      var request = http.MultipartRequest(

        'POST',

        Uri.parse(
          'http://10.0.2.2:8000/predict',
        ),
      );

      request.files.add(

        http.MultipartFile.fromBytes(

          'file',

          imageBytes,

          filename: 'drawing.png',
        ),
      );

      var response =
      await request.send();

      if (response.statusCode == 200) {

        final responseString =
        await response.stream
            .bytesToString();

        final json = jsonDecode(
          responseString,
        );

        setState(() {

          prediction =
          json['prediction'];

          confidence =
          json['confidence'];

          isLoading = false;
        });

      } else {

        setState(() {
          isLoading = false;
        });

        debugPrint(
          'Request failed',
        );
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
                  drawingKey.currentContext!
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

                  decoration: BoxDecoration(

                    color: Colors.white,

                    border: Border.all(
                      color: Colors.black12,
                    ),
                  ),

                  child: CustomPaint(

                    painter: DrawingPainter(
                      points,
                    ),

                    child: Container(),
                  ),
                ),
              ),
            ),
          ),

          Padding(

            padding: const EdgeInsets.all(16),

            child: Column(

              children: [

                Row(

                  children: [

                    Expanded(

                      child: ElevatedButton(

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

                    const SizedBox(width: 16),

                    Expanded(

                      child: ElevatedButton(

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

                const SizedBox(height: 24),

                isLoading

                    ? const CircularProgressIndicator()

                    : Text(

                  prediction.isEmpty

                      ? "Draw something"

                      : "$prediction "
                      "(${(confidence * 100).toStringAsFixed(1)}%)",

                  style: const TextStyle(

                    fontSize: 20,

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}