import 'package:demoaiemo/util/progress_arc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:camera/camera.dart';
import '../main.dart';
import 'dart:io'; // Dosya işlemleri için

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  CameraDevice? cameraDevice;
  int selectedCamIdx = 1;
  double progress = 0.0; // Progress of emotion prediction
  File? capturedImageFile; // Tutulan fotoğraf dosyası

  String? emotion = "Mutlu"; // Default duygu

  Map<String, int> emotionCounts = {
    "Öfkeli": 0,
    "Mutlu": 0,
    "Üzgün": 0,
  };
  bool isModelBusy = false; // Başlangıçta model meşgul değil
  bool isCameraInitialized = false; // Daha kamera başlamadı
  bool isBackButtonOn = false;

  List<String>? labels;

  @override
  void initState() {
    // Get available cameras
    loadModel();
    loadCamera();
    super.initState();
  }

  Future<CameraController?> loadCamera() async {
    cameraController = CameraController(
      cameras![selectedCamIdx],
      ResolutionPreset.max,
      enableAudio: false,
    );

    // Kamera kontrolörü başlatılıyor
    await cameraController!.initialize(); 
    isCameraInitialized = true;

    if (!isModelBusy) {
      cameraController!.startImageStream((imageStream) async {
        cameraImage = imageStream; // Modele java formatında resim yüklemek için
        runModel(cameraImage);
      });
    }
    return cameraController;
  }

  Uint8List convertPlaneToBytes(Plane plane) {
    final WriteBuffer allBytes = WriteBuffer();
    allBytes.putUint8List(plane.bytes);
    return allBytes.done().buffer.asUint8List();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> runModel(input) async {
    if (cameraImage != null && cameraImage!.planes.isNotEmpty && !isModelBusy) {
      isModelBusy = true; // Mark interpreter as busy
      try {
        // Dönüşümü düz pozisyonda ayarlıyoruz
        var predictions = await Tflite.runModelOnFrame(
          bytesList: cameraImage!.planes
              .map<Uint8List>((Plane plane) => convertPlaneToBytes(plane))
              .toList(),
          imageHeight: cameraImage!.height,
          imageWidth: cameraImage!.width,
          imageMean: 0,
          imageStd: 255,
          rotation: 0, // Düz pozisyon için 0 derece ayarlanıyor
          numResults: 3,
          threshold: 0.1,
          asynch: true,
        );

        if (predictions != null && predictions.isNotEmpty) {
          for (var element in predictions) {
            setState(() {
              emotion = element['label'];
              emotionCounts[emotion!] = (emotionCounts[emotion] ?? 0) + 1;
              progress = (emotionCounts[emotion]! / 50.0).clamp(0.0, 1.0); // 0.0 ile 1.0 arasında tut
            });
          }
          if (emotionCounts[emotion] != null && emotionCounts[emotion]! == 50) {
            await captureImage(); // 50. resim çekiliyor
            cameraController!.stopImageStream();
            Navigator.pushReplacementNamed(context, '/verificationpage',
                arguments: {"emotion": emotion, "capturedImageFile": capturedImageFile});
            await stopCameraAndModel();
          }
        }
      } catch (e) {
        debugPrint("Error running model: $e");
      } finally {
        isModelBusy = false; // Çıkarım tamamlandıktan sonra interpreter'ı müsait yap
      }
    }
  }

  Future<void> captureImage() async {
    final image = await cameraController!.takePicture(); // Resim çekiliyor
    setState(() {
      capturedImageFile = File(image.path); // Çekilen resim dosya olarak kaydediliyor
    });
  }

  Future<void> stopCameraAndModel() async {
    await Tflite.close(); // Önce modeli durdur
    try {
      await cameraController!.stopImageStream();
      await cameraController!.dispose();
      isCameraInitialized = false;
    } catch (e) {
      debugPrint("Error stopping camera: $e");
    }
  }

  @override
  void dispose() {
    stopCameraAndModel();
    super.dispose();
  }

  void switchCamera() async {
    selectedCamIdx = (selectedCamIdx + 1) % cameras!.length;
    await cameraController?.dispose(); // Kapat
    initState(); // Yeniden yükle
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isBackButtonOn; // Geri butonunun çalışmasını kontrol et
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Duygu Analizi"),
          automaticallyImplyLeading: false,
          leading: BackButton(
            color: Theme.of(context).colorScheme.onSecondary,
            onPressed: () {
              setState(() {
                isBackButtonOn = true;
              });
            },
          ),
        ),
        body: SingleChildScrollView( // Scroll özelliği burada ekleniyor
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 10,
              ),
              Stack(
                children: [
                  cameraController != null && cameraController!.value.isInitialized
                      ? CameraPreview(cameraController!)
                      : const Center(child: CircularProgressIndicator()),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Text(
                      "Şu anki Duygu: $emotion",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    right: 15,
                    child: IconButton(
                      icon: Icon(Icons.switch_camera,
                          color: Theme.of(context).colorScheme.inversePrimary),
                      onPressed: switchCamera,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Circular_arc(progress: progress),
                  SizedBox(width: 45),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
