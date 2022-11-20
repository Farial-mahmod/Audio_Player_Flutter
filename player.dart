import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:test_defend/player_buttons.dart';

class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  AudioPlayer? _audioPlayer;

  var runningTime, totalDuration, totalSeconds, fullLength;
  var myChapterIter;

  int iter = 0;
  List<File> chapterNames = [
    File('assets/audio/Chunari.mp3'),
    File('assets/audio/junglebook.mp3'),
    File('assets/audio/Chunari.mp3'),
  ];

  // List<File> files = [File('/home/devpc/b.dart'), File('/home/devpc/c.cpp')];
  // int iter = 0;
  // print(files[iter]);
  // iter+=1;
  // print(files[iter]);
  // print(files[0].runtimeType.toString());

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Local Audio files

    _audioPlayer!.setAsset(chapterNames[iter].path);

    //get iterator to the list
    myChapterIter = chapterNames.iterator;
    //iterate over the list

    /// URL based play
    // _audioPlayer!.setAsset("assets/audio/junglebook.mp3");
    // _audioPlayer!.setAudioSource(ConcatenatingAudioSource(children: [
    //   AudioSource.uri(Uri.parse(
    //       "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
    //   AudioSource.uri(Uri.parse(
    //       "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
    // ])).catchError((error) {
    //   debugPrint("Error Here: $error");
    // });
  }

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Timer interval(Duration duration, func) {
    Timer function() {
      Timer timer = Timer(duration, function);
      func(timer);
      return timer;
    }

    return Timer(duration, function);
  }

  formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    runningTime = "$minute : $second";
  }

  audioDuration() {
    _audioPlayer!.durationStream.first.then((event) async {
      if (event != null) {
        int newevent = event.inSeconds;
        await _audioPlayer!.setClip(
            start: const Duration(milliseconds: 0),
            end: Duration(milliseconds: newevent));

        var minutes = (newevent / 60);
        var minutesStr = (minutes % 60).toString().padLeft(2, '0');

        var abc = minutesStr;
        int sec;
        sec = int.tryParse(abc.toString().split('.')[1].substring(0, 2))!;

        setState(() {
          totalDuration = minutesStr.split('.').first;
          totalSeconds = sec;
          print(totalDuration);
          print(totalSeconds);
          fullLength = totalDuration;
          fullLength = int.parse(fullLength);
          assert(fullLength is int);
          print('here');
          print(fullLength.toInt());
          print(fullLength.toDouble());
        });
      }
    });
  }

  // Main UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 114,
            ),

            const Text(
              "Audio Book Player",
              style: TextStyle(fontSize: 35),
            ),

            const SizedBox(
              height: 95,
            ),

            PlayerButtons(_audioPlayer!),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Shuffle
                IconButton(
                    color: Colors.teal,
                    icon: const Icon(Icons.shuffle),
                    onPressed: () {
                      // Old is Gold .
                      setState(() {
                        chapterNames.shuffle();
                        _audioPlayer!.setAsset(chapterNames[iter].path);
                      });
                    }),

                /// Previous
                IconButton(
                    icon: const Icon(Icons.skip_previous),
                    color: Colors.blueGrey,
                    onPressed: () {
                      // Old is Gold .
                      setState(() {
                        iter -= 1;
                        _audioPlayer!.setAsset(chapterNames[iter].path);
                      });
                    }),

                /// Next
                IconButton(
                    icon: const Icon(Icons.skip_next),
                    color: Colors.blueGrey,
                    onPressed: () {
                      // Old is Gold .
                      setState(() {
                        iter += 1;
                        _audioPlayer!.setAsset(chapterNames[iter].path);
                      });
                    }),

                /// Repeat
                IconButton(
                    icon: const Icon(Icons.repeat_outlined),
                    color: Colors.teal,
                    onPressed: () {
                      // Old is Gold .
                      setState(() {
                        _audioPlayer!.setAsset(chapterNames[iter].path);
                      });
                    }),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Initial Time
                Text(runningTime == null ? "0:00" : runningTime.toString()),

                /// Total Time
                Text(("$totalDuration:$totalSeconds") == null
                    ? '0:00'
                    : ('10' + ":" + '00')),
              ],
            ),

            /// Progress
            // Padding(
            //   padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            //   child: ProgressBar(
            //     progressBarColor: Colors.red,
            //     baseBarColor: Colors.purple.withOpacity(0.24),
            //     bufferedBarColor: Colors.blue.withOpacity(0.24),
            //     thumbColor: Colors.black,
            //     barHeight: 3.0,
            //     thumbRadius: 5.0,
            //     progress: Duration(seconds: 0),
            //     buffered: Duration(seconds: 5),
            //     total: Duration(minutes: 0, seconds: 1),
            //     onSeek: (duration) {
            //       setState(() {
            //         _audioPlayer!.seek(Duration(seconds: 10));
            //       });
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
