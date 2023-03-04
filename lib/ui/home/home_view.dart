import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:stacked/stacked.dart';
import 'package:video_app/ui/home/home_viewmodel.dart';
import 'package:video_player/video_player.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) {
        model.getVideoController(
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4');
      },
      builder: (context, model, child) {
        if (model.videoPalyerController != null &&
            model.videoPalyerController!.value.isInitialized) {
          return Scaffold(
            body: Center(
              child: AspectRatio(
                aspectRatio: model.videoPalyerController!.value.aspectRatio,
                child: VideoPlayer(model.videoPalyerController!),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                model.downloadVideo(context);
              },
              child: const Icon(Icons.download),
            ),
          );
        }
        return const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}
