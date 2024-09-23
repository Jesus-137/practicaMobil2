import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      home: const Reto2Screen(),
    );
  }
}

class Reto2Screen extends StatefulWidget {
  const Reto2Screen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<Reto2Screen> {
  List<dynamic> _todos = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/'));

    if (response.statusCode == 200) {
      setState(() {
        _todos = json.decode(response.body);
        _isLoading = false;
      });
      _showTodo();
    } else {
      setState(() {
        _isLoading = false;
      });
      // Manejo de errores aquí (opcional)
    }
  }

  void _showTodo() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentIndex < _todos.length) {
        setState(() {
          _currentIndex++;
        });
      } else {
        timer.cancel(); // Detenemos el timer cuando se han mostrado todos los elementos
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: _currentIndex < _todos.length
                  ? Text(
                      _todos[_currentIndex]['title'],
                      style: const TextStyle(fontSize: 24),
                    )
                  : const Text('No hay más tareas'),
            ),
    );
  }
}
