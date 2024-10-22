import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Packages Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Reto3Screen(),
    );
  }
}

class Reto3Screen extends StatefulWidget {
  const Reto3Screen({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Reto3Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Packages Demo')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Geolocation'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GeolocationPage()),
            ),
          ),
          ListTile(
            title: Text('QR Code Scanner'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QRCodePage()),
            ),
          ),
          ListTile(
            title: Text('Sensor Data'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SensorPage()),
            ),
          ),
          ListTile(
            title: Text('Speech to Text'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpeechToTextPage()),
            ),
          ),
          ListTile(
            title: Text('Text to Speech'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TextToSpeechPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class GeolocationPage extends StatefulWidget {
  @override
  _GeolocationPageState createState() => _GeolocationPageState();
}

class _GeolocationPageState extends State<GeolocationPage> {
  String _location = 'Unknown';

  void _getCurrentLocation() async {
    // Solicitar permisos de ubicación
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }

    // Verificar si el permiso ha sido concedido
    if (await Permission.location.isGranted) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = '${position.latitude}, ${position.longitude}';
      });
    } else {
      // Manejar el caso donde el permiso no fue concedido
      setState(() {
        _location = 'Location permission denied';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Geolocation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current Location: $_location'),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Text('Get Location'),
            ),
          ],
        ),
      ),
    );
  }
}

class QRCodePage extends StatefulWidget {
  @override
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scanner')),
      body: Center(
        child: QrImageView(
          data: '1234567890',
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}

class SensorPage extends StatefulWidget {
  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  double _accelerometerX = 0.0, _accelerometerY = 0.0, _accelerometerZ = 0.0;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerX = event.x;
        _accelerometerY = event.y;
        _accelerometerZ = event.z;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sensor Data')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Accelerometer:'),
            Text('X: $_accelerometerX'),
            Text('Y: $_accelerometerY'),
            Text('Z: $_accelerometerZ'),
          ],
        ),
      ),
    );
  }
}

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (result) {
          setState(() => _text = result.recognizedWords);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Speech to Text')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_text),
            ElevatedButton(
              onPressed: _listen,
              child: Text(_isListening ? 'Stop Listening' : 'Listen'),
            ),
          ],
        ),
      ),
    );
  }
}

class TextToSpeechPage extends StatefulWidget {
  @override
  _TextToSpeechPageState createState() => _TextToSpeechPageState();
}

class _TextToSpeechPageState extends State<TextToSpeechPage> {
  FlutterTts _flutterTts = FlutterTts();
  TextEditingController _controller = TextEditingController();

  void _speak() async {
    if (_controller.text.isNotEmpty) {
      await _flutterTts.speak(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Text to Speech')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: 'Enter text'),
            ),
            ElevatedButton(
              onPressed: _speak,
              child: Text('Speak'),
            ),
          ],
        ),
      ),
    );
  }
}