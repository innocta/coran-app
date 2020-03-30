import 'package:coranapp/view-model.dart';
import 'package:flutter/material.dart';

import 'audio-player-manager.dart';
import 'coran-data.dart';
import 'state/models.dart';

class AudioPlayerController extends StatefulWidget {
  final ViewModel model;
  final CoranData coranData;
  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerControllerState(coranData);
  }
  AudioPlayerController(this.model, this.coranData) {}
}

class _AudioPlayerControllerState extends State<AudioPlayerController> {
  AudioPlayerManager audioPlayerManager;
  final CoranData coranData;

  _AudioPlayerControllerState(this.coranData) {}

  buildIcon () {
    print(widget.model.playStatus.isPlaying);
    if (widget.model != null && widget.model.playStatus.isPlaying) {
      return new Icon(Icons.pause);
    }
    return new Icon(Icons.play_arrow);
  }

  pressedPlayHandler () {
    if (widget.model.playStatus.isPlaying)
      this.audioPlayerManager.pause(widget.model.playStatus.coranDataInfo);
    else
      this.audioPlayerManager.play(widget.model.playStatus.coranDataInfo);
  }

  pressedNexPlayHandler () {
    print(widget.model.playStatus.coranDataInfo);
    CoranDataInfo nextCoranDataInfo = this.coranData.getNextCoranDataInfo(widget.model.playStatus.coranDataInfo);
    if (nextCoranDataInfo != null) {
      this.audioPlayerManager.play(nextCoranDataInfo);
      print("next");
    }
  }

  pressedPreviousPlayHandler () {
    print(widget.model.playStatus.coranDataInfo);
    CoranDataInfo nextCoranDataInfo = this.coranData.getPreviousCoranDataInfo(widget.model.playStatus.coranDataInfo);
    if (nextCoranDataInfo != null) {
      this.audioPlayerManager.play(nextCoranDataInfo);
    }
  }

  @override
  Widget build(BuildContext context) {
    audioPlayerManager = new AudioPlayerManager(widget.model);
    return BottomAppBar(
      child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new IconButton(icon: new Icon(Icons.fast_rewind), onPressed: () => this.pressedPreviousPlayHandler()),
              new IconButton(icon: buildIcon(), onPressed: () => this.pressedPlayHandler()),
              new IconButton(icon: new Icon(Icons.fast_forward), onPressed: () => this.pressedNexPlayHandler()),
            ],
          ),
          subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("surat"),
              ]
          )
      ),
    );
  }

}