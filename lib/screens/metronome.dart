import 'package:flutter/material.dart';
import '../widgets/metronome/slider.dart';
import '../widgets/metronome/indicator.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Metronome extends StatefulWidget {
  @override
  State<Metronome> createState() => _MetronomeState();
}

class _MetronomeState extends State<Metronome>
    with SingleTickerProviderStateMixin {
  // starting bpm
  int _bpm = 70;
  int _nowStep = -1;
  bool _isRunning = false;
  late Timer timer;
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  late AnimationController _animationController;
  int soundType = 0;

  void _setBpmHanlder(int val) {
    setState(() {
      _bpm = val;
    });
  }

  void _toggleIsRunning() {
    if (_isRunning) {
      timer.cancel();
      _animationController.reverse();
    } else {
      runTimer();
      _animationController.forward();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  void _setNowStep() {
    setState(() {
      _nowStep++;
    });
  }

  Future<void> _playAudio() {
    int nextStep = _nowStep + 1;
    if (nextStep % 4 == 0) {
      return assetsAudioPlayer.open(Audio('assets/metronome$soundType-1.mp3'));
    } else {
      return assetsAudioPlayer.open(Audio('assets/metronome$soundType-2.mp3'));
    }
  }

  void runTimer() {
    timer = Timer(Duration(milliseconds: (60 / _bpm * 1000).toInt()), () {
      _playAudio().then((value) => _setNowStep());
      runTimer();
    });
  }

  Future setBpm() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? bpm = prefs.getInt('bpm');
    if (bpm != null) {
      print('get bpm $bpm');
      _setBpmHanlder(bpm);
    }
  }

  Future setSoundType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? soundType = prefs.getInt('sound');
    if (soundType != null) {
      print('get sound type $soundType');
      this.soundType = soundType;
    }
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      Wakelock.enable();
    }
    setSoundType();
    setBpm();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
          title: Text(
            "Metronome",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              SliderRow(_bpm, _setBpmHanlder, _isRunning, _toggleIsRunning,
                  _animationController),
              Indicator(_nowStep),
            ],
          ),
        ));
  }
}
