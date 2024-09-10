import 'package:flutter/material.dart';

class Reto3Screen extends StatelessWidget {
  const Reto3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: const Text('Reto 3'),
	  ),
	  body: const Center(
		child: Text('Contenido del Reto 3'),
	  ),
	);
  }
}