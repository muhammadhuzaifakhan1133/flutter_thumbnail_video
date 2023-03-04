import 'dart:io';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter/media_information_session.dart';
import 'package:ffmpeg_kit_flutter/session_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_app/helper/parse_duration.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoService {
  static VideoPlayerController getVideoController(String videoURL) {
    return VideoPlayerController.network(videoURL);
  }

  static Future<File> downloadVideo(String dataSource) async {
    var response = await http.get(Uri.parse(dataSource));
    final directory = await getExternalStorageDirectory();
    final Directory appDocDirFolder = Directory('${directory!.path}/video_app');
    final Directory appDocDirNewFolder =
        await appDocDirFolder.create(recursive: true);
    final path = appDocDirNewFolder.path;
    File file = File("$path/video.mp4");
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  static Future<void> addThumbnailToVideo(
      String videoPath, String thumbnailPath) async {
    // Get the duration of the video using FFprobeKit
    MediaInformationSession fFprobeKitReturn =
        await FFprobeKit.getMediaInformation(videoPath);
    String? durationString =
        fFprobeKitReturn.getMediaInformation()!.getDuration();
    print('Duration: $durationString');
    // Set the time to take the thumbnail as half of the video duration
    double thumbnailTime = double.parse(durationString!) / 2;

    // Build the FFmpeg command to add the thumbnail to the video
    String command =
        '-y -i $videoPath -ss $thumbnailTime -vframes 1 $thumbnailPath';

    // Execute the FFmpeg command asynchronously using FFmpegKit
    FFmpegKit.execute(command).then((session) async {
      if (await session.getState() == SessionState.created) {
        print('Thumbnail added successfully');
      } else {
        print('Error adding thumbnail: ${await session.getAllLogsAsString()}');
      }
    });
  }
}
