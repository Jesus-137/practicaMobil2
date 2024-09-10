import 'package:flutter/material.dart';

class Reto2Screen extends StatelessWidget {
  const Reto2Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: const Text('Reto 2'),
	  ),
	  body: const Center(
		child: Text('Contenido del Reto 2'),
	  ),
	);
  }
}