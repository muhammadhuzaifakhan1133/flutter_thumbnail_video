import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:stacked/stacked.dart';
import 'package:video_app/services/video_services.dart';
import 'package:video_app/utils/dialogs.dart';
import 'package:video_app/utils/images.dart';
import 'package:video_app/utils/snackbars.dart';
import 'package:video_player/video_player.dart';

class HomeViewModel extends BaseViewModel {
  VideoPlayerController? videoPalyerController;

  getVideoController(String videoURL) async {
    videoPalyerController = VideoService.getVideoController(videoURL);
    await videoPalyerController!.initialize();
    videoPalyerController!.play();
    notifyListeners();
  }

  downloadVideo(context) async {
    Dialogs.showLoadingDialog(context);
    File file =
        await VideoService.downloadVideo(videoPalyerController!.dataSource);
    await VideoService.addThumbnailToVideo(file.path, Images.thumbnail);
    SnackBars.showSnackBar(
        context: context,
        content: Text('Video file downloaded to ${file.path}'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () {
            OpenFilex.open(file.path);
          },
        ));
    Dialogs.closeDialog(context);
  }
}
