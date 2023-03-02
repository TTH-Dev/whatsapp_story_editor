import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_crop_plus/image_crop_plus.dart';
import 'package:whatsapp_story_editor/src/controller/editing_controller.dart';
import 'package:whatsapp_story_editor/src/controller/utils.dart';
import 'package:whatsapp_story_editor/src/widgets/icon_widget.dart';

class CropView extends StatefulWidget {
  final File image;
  const CropView({Key? key, required this.image}) : super(key: key);

  @override
  State<CropView> createState() => _CropViewState();
}

class _CropViewState extends State<CropView> {
  final EditingController controller = Get.find<EditingController>();
  final cropKey = GlobalKey<CropState>();
  int rotation = 0;
  double angle = 0;
  late File imageToCrop;

  @override
  void initState() {
    imageToCrop = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Transform.rotate(
                  angle: controller.rotationAngle,
                  child: Center(
                    child: Container(
                      constraints: BoxConstraints.tightFor(
                          // this specific height and width so it gets fit when flipped
                          height: MediaQuery.of(context).size.width * 0.95,
                          width: MediaQuery.of(context).size.height * 0.80),
                      child: Crop(
                        alwaysShowGrid: true,
                        image: FileImage(widget.image),
                        key: cropKey,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        bottomNavigationBar: _bottomBar(),
      ),
    );
  }

  _bottomBar() {
    double screenWid = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: screenWid * 0.10, vertical: 12.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
                height: 40,
                width: screenWid * 0.65 / 2,
                alignment: Alignment.centerLeft,
                child: const Text("Cancel",
                    style: TextStyle(color: Colors.white)))),
        buildIcon(
            icon: Icons.rotate_90_degrees_ccw,
            onTap: () {
              setState(() {
                rotation++;
                rotation > 3
                    ? rotation = 0
                    : rotation < 0
                        ? rotation = 0
                        : rotation;

                rotation == 0
                    ? angle = 2 * math.pi
                    : rotation == 1
                        ? angle = math.pi / 2
                        : rotation == 2
                            ? angle = math.pi
                            : rotation == 3
                                ? angle = 3 * math.pi / 2
                                : 0;
                controller.rotation = rotation;
                controller.rotationAngle = angle;
              });
            }),
        GestureDetector(
            onTap: () {
              _cropAndNotifyImage();
            },
            child: Container(
                alignment: Alignment.centerRight,
                height: 40,
                width: screenWid * 0.65 / 2,
                child:
                    const Text("Done", style: TextStyle(color: Colors.white)))),
      ]),
    );
  }

  Future<void> _cropAndNotifyImage() async {
    final scale = cropKey.currentState!.scale;
    final area = cropKey.currentState!.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger

    final sample = await ImageCrop.sampleImage(
      file: widget.image,
      preferredSize: (2000 / scale).round(),
    );

    File file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    // _lastCropped?.delete();
    // debugPrint(' file:::: $file --- $_lastCropped');
    Get.find<EditingController>().backgroundImage = file;
    setState(() {});
    delayFunction(milliseconds: 800, todo: () => Navigator.of(context).pop());
  }
}
