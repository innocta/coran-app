import 'package:coranapp/state/models.dart';
import 'package:coranapp/view-model.dart';
import 'package:flutter/material.dart';

import 'audio-player-manager.dart';
import 'choise.dart';
import 'coran-data.dart';

class ChoiceCard extends StatefulWidget {
  final Choice choice;
  final ViewModel model;
  final CoranData coranData;

  @override
  State<StatefulWidget> createState() {
    return _ChoiceCardState(this.choice, this.coranData);
  }
  ChoiceCard(this.choice, this.model, this.coranData) {}
}

enum PlayerState { stopped, playing, paused }



class _ChoiceCardState extends State<ChoiceCard> {

  final Choice choice;
  final CoranData coranData;
  PlayerState playerState = PlayerState.stopped;
  AudioPlayerManager audioPlayerManager;

  _ChoiceCardState(this.choice, this.coranData) {}

  Widget _buildSuggestions(List<CoranDataInfo> listOfContents) {
    audioPlayerManager = new AudioPlayerManager(widget.model);
    return new ListView.builder(
        itemCount: listOfContents.length,
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (con2text, i) {
          CoranDataInfo coranDataInfo = new CoranDataInfo(
              listOfContents[i].id,
              listOfContents[i].url,
              listOfContents[i].title,
              listOfContents[i].artist,
              listOfContents[i].duration
          );
          return _buildRow(coranDataInfo, i + 1);
        });
  }



  buildIcon (CoranDataInfo coranDataInfo) {
    if (coranDataInfo.id == widget.model.playStatus.coranDataInfo.id) {
      if (widget.model.playStatus.isPlaying)
        return new Icon(Icons.pause);
      else
        return new Icon(Icons.play_arrow);
    }
    return new Icon(Icons.play_arrow);
  }

  isLoading (CoranDataInfo coranDataInfo) {
    if (coranDataInfo.id == widget.model.playStatus.coranDataInfo.id) {
      return widget.model.isLoading;
    }
    return false;
  }

  Widget _buildRow(CoranDataInfo coranDataInfo, int index) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(coranDataInfo.title),
                ),
                isLoading(coranDataInfo) ? CircularProgressIndicator() : Text(""),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(coranDataInfo.artist),
                ),
              ],
            ),
            leading: new IconButton(
              icon: buildIcon(coranDataInfo),
              highlightColor: Colors.pink,
              onPressed: (){
                if (widget.model.playStatus.isPlaying)
                  this.audioPlayerManager.pause(coranDataInfo);
                else
                  this.audioPlayerManager.play(coranDataInfo);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch(choice.title) {
      case "سورة":
        return _buildSuggestions(this.coranData.surats);
      case "أحزاب":
        return _buildSuggestions(this.coranData.ahzab);
      case "اثمان":
        return _buildSuggestions(this.coranData.athman);

    }
  }
}