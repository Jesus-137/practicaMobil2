import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Input, Button, Label Example',
      home: const Reto1Screen(),
    );
  }
}

class Reto1Screen extends StatefulWidget {
  const Reto1Screen({super.key});

  @override
  _InputButtonLabelScreenState createState() => _InputButtonLabelScreenState();
}

class _InputButtonLabelScreenState extends State<Reto1Screen> {
  final TextEditingController _controller = TextEditingController();
  String _labelText = "Ingrese algo y presione el botón";

  Future<void> _makeHttpRequest(String input) async {
    // Aquí se realiza una solicitud HTTP simulada (puedes cambiarla a tu URL).
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'));

    if (response.statusCode == 200) {
      setState(() {
        _labelText = 'Respuesta: ${json.decode(response.body)['title']}';
      });
    } else {
      setState(() {
        _labelText = 'Error: No se pudo obtener la respuesta';
      });
    }
  }

  void _onButtonPressed() {
    if (_controller.text.isNotEmpty) {
      _makeHttpRequest(_controller.text);
    } else {
      setState(() {
        _labelText = 'Por favor, ingrese un valor';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input, Button, Label'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFieldClass(controller: _controller),
            const SizedBox(height: 20),
            ButtonStyleClass(onPressed: _onButtonPressed),
            const SizedBox(height: 20),
            Text(_labelText),
          ],
        ),
      ),
    );
  }
}

class TextFieldClass extends StatelessWidget {
  final TextEditingController controller;

  const TextFieldClass({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Ingrese texto',
      ),
    );
  }
}

class ButtonStyleClass extends StatelessWidget {
  final VoidCallback onPressed;

  const ButtonStyleClass({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.indigo, // Color de fondo del botón
        foregroundColor: Colors.white, // Color del texto y el icono del botón
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: const Text('Enviar'),
    );
  }
}
