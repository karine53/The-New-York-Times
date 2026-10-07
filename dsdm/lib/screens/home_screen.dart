import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

import '../data/regions.dart';
import '../models/news.dart';
import '../models/region_feed.dart';
import '../services/rss_service.dart';
import '../widgets/world_map_painter.dart';

const Color fundo = Color(0xFF071B2D);
const Color azulCard = Color(0xFF193A5B);
const Color laranja = Color(0xFFFF6538);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RssService rssService = RssService();

  late RegionFeed regiaoSelecionada;
  List<News> noticias = [];

  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    regiaoSelecionada = regions.firstWhere(
      (regiao) => regiao.name == 'Europa',
      orElse: () => regions.first,
    );
    carregarNoticias();
  }

  Future<void> carregarNoticias() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final resultado =
          await rssService.getNews(regiaoSelecionada.url);

      if (!mounted) return;

      setState(() {
        noticias = resultado;
        carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        noticias = [];
        erro = 'Não foi possível carregar as notícias. '
            'Verifique sua conexão e tente novamente.';
        carregando = false;
      });
    }
  }

  void selecionarRegiao(RegionFeed regiao) {
    if (regiao.name == regiaoSelecionada.name) return;

    setState(() {
      regiaoSelecionada = regiao;
    });

    carregarNoticias();
  }

  Color corDaRegiao(String nome) {
    switch (nome) {
      case 'África':
        return const Color(0xFFFFBD45);
      case 'Américas':
        return const Color(0xFF4C91FF);
      case 'Ásia-Pacífico':
        return const Color(0xFF8C78F4);
      case 'Europa':
        return laranja;
      case 'Oriente Médio':
        return const Color(0xFF45D6B0);
      default:
        return const Color(0xFFEA70BB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: carregarNoticias,
                color: laranja,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 24),
                  children: [
                    _cabecalho(),
                    const SizedBox(height: 18),
                    _mapa(),
                    const SizedBox(height: 18),
                    _botoesRegioes(),
                    const SizedBox(height: 22),
                    _tituloNoticias(),
                    const SizedBox(height: 12),
                    _listaNoticias(),
                  ],
                ),
              ),
            ),
            _barraInferior(),
          ],
        ),
      ),
    );
  }

  Widget _cabecalho() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: laranja,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            const Text(
              'EXPLORE AO VIVO',
              style: TextStyle(
                color: laranja,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                'World News Map',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.6,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24),
              ),
              child: IconButton(
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: BuscaNoticiasDelegate(noticias),
                  );
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        const Text(
          'Explore notícias pelo mundo',
          style: TextStyle(
            color: Color(0xFF9FB5CC),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _mapa() {
    return Container(
      height: 245,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A1E31),
            Color(0xFF102F53),
            Color(0xFF173D69),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GradeMapaPainter(),
            ),
          ),
          Positioned.fill(
            child: WorldMapPainter(
              regiaoSelecionada: regiaoSelecionada.name,
              aoSelecionar: selecionarPorNome,
            ),
          ),
        ],
      ),
    );
  }

  void selecionarPorNome(String nome) {
    final correspondencias = regions.where(
      (regiao) => regiao.name == nome,
    );

    if (correspondencias.isNotEmpty) {
      selecionarRegiao(correspondencias.first);
    }
  }

  Widget _botoesRegioes() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: regions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final regiao = regions[index];
          final selecionada =
              regiao.name == regiaoSelecionada.name;

          return InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => selecionarRegiao(regiao),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: selecionada ? laranja : azulCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: selecionada
                      ? laranja
                      : Colors.white.withValues(alpha: 0.14),
                ),
              ),
              child: Text(
                regiao.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: selecionada
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _tituloNoticias() {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${regiaoSelecionada.name.toUpperCase()} · NOTÍCIAS',
            style: const TextStyle(
              color: laranja,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.6,
            ),
          ),
        ),
        if (!carregando && erro == null)
          Text(
            '${noticias.length} notícias',
            style: const TextStyle(
              color: Color(0xFF9FB5CC),
              fontSize: 11,
            ),
          ),
      ],
    );
  }

  Widget _listaNoticias() {
    if (carregando) {
      return const Padding(
        padding: EdgeInsets.all(35),
        child: Center(
          child: CircularProgressIndicator(color: laranja),
        ),
      );
    }

    if (erro != null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: azulCard,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.wifi_off,
              color: Colors.white70,
              size: 30,
            ),
            const SizedBox(height: 10),
            Text(
              erro!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: laranja,
              ),
              onPressed: carregarNoticias,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (noticias.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          'Nenhuma notícia encontrada nesta região.',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Column(
      children: noticias.take(10).map((noticia) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: azulCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                regiaoSelecionada.name.toUpperCase(),
                style: TextStyle(
                  color: corDaRegiao(regiaoSelecionada.name),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                noticia.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              if (noticia.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  noticia.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFB9C9D9),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: laranja,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (noticia.url.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Link da notícia copiado? '
                            'A abertura no navegador será adicionada depois.',
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.arrow_forward, size: 17),
                  label: const Text('Explorar notícia'),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _barraInferior() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF08192A),
        border: Border(
          top: BorderSide(color: Colors.white12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _itemMenu(Icons.public, 'Mapa', true),
          _itemMenu(Icons.search, 'Busca', false, aoTocar: () {
            showSearch(
              context: context,
              delegate: BuscaNoticiasDelegate(noticias),
            );
          }),
          _itemMenu(Icons.bookmark_border, 'Favoritos', false),
          _itemMenu(Icons.settings_brightness, 'Ajustes', false),
        ],
      ),
    );
  }

  Widget _itemMenu(
    IconData icone,
    String titulo,
    bool selecionado, {
    VoidCallback? aoTocar,
  }) {
    return InkWell(
      onTap: aoTocar,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              color: selecionado ? laranja : Colors.blueGrey[300],
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: TextStyle(
                color: selecionado ? laranja : Colors.blueGrey[300],
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuscaNoticiasDelegate extends SearchDelegate<News?> {
  final List<News> noticias;

  BuscaNoticiasDelegate(this.noticias);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.clear),
        ),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back),
      );

  @override
  Widget buildResults(BuildContext context) => _resultados();

  @override
  Widget buildSuggestions(BuildContext context) => _resultados();

  Widget _resultados() {
    final encontrados = noticias.where((noticia) {
      return noticia.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (encontrados.isEmpty) {
      return const Center(child: Text('Nenhuma notícia encontrada.'));
    }

    return ListView.builder(
      itemCount: encontrados.length,
      itemBuilder: (context, index) {
        final noticia = encontrados[index];

        return ListTile(
          title: Text(noticia.title),
          subtitle: Text(
            noticia.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}