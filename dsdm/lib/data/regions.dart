import '../models/region_feed.dart';

final regions = [
  RegionFeed(
    name: 'África',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/Africa.xml',
    // Feeds RSS usados para buscar notícias, separados por regiões do mundo.
    // xml organiza os dados das notícias em uma estrutura que o aplicativo consegue ler.
    // rss fornece o conteudo da noticia 
  ),
  RegionFeed(
    name: 'Américas',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/Americas.xml',
  ),
  RegionFeed(
    name: 'Ásia-Pacífico',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml',
  ),
  RegionFeed(
    name: 'Europa',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml',
  ),
  RegionFeed(
    name: 'Oriente Médio',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/MiddleEast.xml',
  ),
  RegionFeed(
    name: 'Mundo',
    url: 'https://rss.nytimes.com/services/xml/rss/nyt/World.xml',
  ),
];