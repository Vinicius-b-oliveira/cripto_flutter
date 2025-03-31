import 'package:cripto_flutter/models/moeda.dart';
import 'package:flutter/material.dart';

class MoedasDetalhesPage extends StatefulWidget {
  final Moeda moeda;
  const MoedasDetalhesPage({super.key, required this.moeda});

  @override
  State<MoedasDetalhesPage> createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.moeda.nome)),
      body: Column(
        children: [
          Divider(),
          Row(
            children: [
              SizedBox(width: 50, child: Image.asset(widget.moeda.icone)),
            ],
          ),
        ],
      ),
    );
  }
}
