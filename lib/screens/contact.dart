import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(const ContactApp());

class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFC1A8), // Botón flotante en color naranja
        ),
      ),
      home: const ContactScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Map<String, String>> _contacts = [
    {'name': 'Jorge Alexis Arredondo Juárez', 'matricula': '221187', 'phone': '9611426549'},
    {'name': 'Jesus Ignacio Velazquez Hernandez', 'matricula': '221225', 'phone': '9614481328'}
  ];
  bool _showContacts = true;

  // Método para enviar un mensaje de texto a un número específico.
  void _sendMessage(String number) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: number,
    );
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      _showSnackbarMessage('No se pudo enviar el mensaje a $number');
    }
  }

  // Método para realizar una llamada telefónica a un número específico.
  void _makeCall(String number) async {
    // Solicitar permiso de llamada en tiempo de ejecución
    if (await Permission.phone.request().isGranted) {
      final Uri telUri = Uri(
        scheme: 'tel',
        path: number,
      );
      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        _showSnackbarMessage('No se pudo realizar la llamada a $number');
      }
    } else {
      _showSnackbarMessage('Permiso de llamada no concedido');
    }
  }

  void _toggleContacts() {
    setState(() {
      if (_showContacts) {
        if (_contacts.isNotEmpty) {
          for (int i = _contacts.length - 1; i >= 0; i--) {
            _listKey.currentState?.removeItem(
              i,
              (context, animation) => _buildItem(_contacts[i], animation),
              duration: const Duration(milliseconds: 500),
            );
          }
        }
      } else {
        for (int i = 0; i < _contacts.length; i++) {
          _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 500));
        }
      }
      _showContacts = !_showContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Contactos', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              // Acción de búsqueda
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (String value) {
              // Acción de menú seleccionada
            },
            itemBuilder: (BuildContext context) {
              return {'Configurar', 'Ayuda'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFDE5E7), Color(0xFFFFC1A8)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _showContacts ? _contacts.length : 0,
              itemBuilder: (context, index, animation) {
                return _buildItem(_contacts[index], animation);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleContacts,
        tooltip: 'Agregar Contactos',
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFFFFC1A8),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.white,
        elevation: 10,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
              ),
              const SizedBox(width: 30),
              IconButton(
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                onPressed: () {
                  Navigator.pushNamed(context, '/contact');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(Map<String, String> contact, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFFFC1A8),
            child: Text(
              contact['name']![0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(contact['name']!),
          subtitle: Text('Matrícula: ${contact['matricula']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green),
                onPressed: () {
                  _makeCall(contact['phone']!);
                },
              ),
              IconButton(
                icon: const Icon(Icons.message, color: Colors.blue),
                onPressed: () {
                  _sendMessage(contact['phone']!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackbarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
