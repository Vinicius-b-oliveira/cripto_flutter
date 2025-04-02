import 'package:cripto_flutter/config/app_settings.dart';
import 'package:cripto_flutter/models/moeda.dart';
import 'package:cripto_flutter/pages/moedas_detalhes_page.dart';
import 'package:cripto_flutter/repositories/favoritas_repository.dart';
import 'package:cripto_flutter/repositories/moeda_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Moeda> selecionadas = [];
  late FavoritasRepository favoritas;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';

    return PopupMenuButton(
      icon: Icon(Icons.language),
      itemBuilder:
          (context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.swap_vert),
                title: Text('Usar $locale'),
                onTap: () {
                  context.read<AppSettings>().setLocale(locale, name);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
    );
  }

  AppBar appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: const Text('Cripto Moedas'),
        actions: [changeLanguageButton()],
      );
    } else {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: limparSelecionadas,
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          // Substitui o textTheme.headline6
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MoedasDetalhesPage(moeda: moeda)),
    );
  }

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    favoritas = context.watch<FavoritasRepository>();
    readNumberFormat();

    return Scaffold(
      appBar: appBarDinamica(),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int moeda) {
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            leading:
                (selecionadas.contains(tabela[moeda]))
                    ? CircleAvatar(child: Icon(Icons.check))
                    : SizedBox(
                      width: 40,
                      child: Image.asset(tabela[moeda].icone),
                    ),
            title: Row(
              children: [
                Text(
                  tabela[moeda].nome,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                ),
                if (favoritas.lista.contains(tabela[moeda]))
                  Icon(Icons.star, color: Colors.amber, size: 12),
              ],
            ),
            trailing: Text(real.format(tabela[moeda].preco)),
            selected: selecionadas.contains(tabela[moeda]),
            selectedTileColor: Colors.indigo[50],
            onLongPress: () {
              setState(() {
                (selecionadas.contains(tabela[moeda]))
                    ? selecionadas.remove(tabela[moeda])
                    : selecionadas.add(tabela[moeda]);
              });
            },
            onTap: () => mostrarDetalhes(tabela[moeda]),
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, ___) => const Divider(),
        itemCount: tabela.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          selecionadas.isNotEmpty
              ? FloatingActionButton.extended(
                onPressed: () {
                  favoritas.saveAll(selecionadas);
                  limparSelecionadas();
                },
                icon: Icon(Icons.star),
                label: Text(
                  'FAVORITAR',
                  style: TextStyle(
                    letterSpacing: 0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
              : null,
    );
  }
}
