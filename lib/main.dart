import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_player/radio_player.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: 'MCF Radio',
      url: 'http://shaincast.caster.fm:34901/listen.mp3?authn4b996f4877e973486ebe817298a54e01',
      imagePath: 'assets/logo5.png',
    );

    _radioPlayer.stateStream.listen((value) {
      setState(() {
        isPlaying = value;
      });
    });

    _radioPlayer.metadataStream.listen((value) {
      setState(() {
        metadata = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.lightBlue),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('MCF Radio'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: _radioPlayer.getArtworkImage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Image artwork;
                  if (snapshot.hasData) {
                    artwork = snapshot.data;
                  } else {
                    artwork = Image.asset(
                      'assets/logo5.png',
                      fit: BoxFit.cover,
                    );
                  }
                  return SizedBox(
                    height: 180,
                    width: 180,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: artwork,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                metadata?[0] ?? 'MCF Radio',
                softWrap: false,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              Text(
                metadata?[1] ?? '',
                softWrap: false,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  _launchURLBrowser();
                },
                child: const Text("Made by Joseph Opio"),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            isPlaying ? _radioPlayer.pause() : _radioPlayer.play();
          },
          tooltip: 'Control button',
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          ),
        ),
      ),
    );
  }
}

_launchURLBrowser() async {
  var url = Uri.parse("https://www.geeksforgeeks.org/");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}
