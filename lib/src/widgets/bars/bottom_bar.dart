import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatsapp_story_editor/src/constants.dart';
import 'package:whatsapp_story_editor/src/controller/editing_controller.dart';
import 'package:whatsapp_story_editor/src/controller/utils.dart';
import 'package:whatsapp_story_editor/src/widgets/circle_widget.dart';
import 'package:whatsapp_story_editor/whatsapp_story_editor.dart';

///Bottom Bar containing the done button and status excluded people status
bottomBar({required BuildContext context}) => Container(
      height:
          MediaQuery.of(context).size.height * Constants.bottomBarHeightRatio,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.teal,
              // backgroundColor: ,
              // onPrimary: Colors.white,
               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
              side: const BorderSide(color: Colors.white, width: 1),
            ),
            onPressed: () async {
              takeScreenshotAndReturnMemoryImage(getScreenshotKey)
                  .then((imageData) {
                Navigator.pop(context);
                Navigator.pop(
                    context,
                    WhatsappStoryEditorResult(
                        image: imageData,
                        caption: Get.find<EditingController>().caption));
              });
            },
            child: const Text(
              "save",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // circleWidget(
          //     radius: 50,
          //     padding: const EdgeInsets.only(left: 5.0),
          //     child: Center(
          //       child: Text(
          //         "save",
          //         style: TextStyle(color: Colors.white),
          //       ),
          //     ),
          //     onTap: () async {
          //       takeScreenshotAndReturnMemoryImage(getScreenshotKey)
          //           .then((imageData) {
          //         Navigator.pop(context);
          //         Navigator.pop(
          //             context,
          //             WhatsappStoryEditorResult(
          //                 image: imageData,
          //                 caption: Get.find<EditingController>().caption));
          //       });
          //     }),
        ],
      ),
    );
