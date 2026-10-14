# World News Map

Aplicativo Flutter que organiza as notícias do The New York Times por região. A interface segue o protótipo do Figma: mapa interativo, notícias em destaque, páginas de região, busca, favoritos e configurações.

## Funcionalidades

- Seis feeds RSS do NYT: África, Américas, Ásia-Pacífico, Europa, Oriente Médio e Mundo.
- Seleção de regiões pelo mapa ou pelos filtros.
- Busca por título e resumo em todas as regiões.
- Tela de leitura com resumo, data de publicação e link para a reportagem original.
- Favoritos, tema, tamanho do texto e preferências de leitura salvos no dispositivo.
- Estados de carregamento, atualização manual, erros de rede e tentativa novamente.

As notícias são carregadas dos feeds RSS públicos do NYT. O feed disponibiliza título, resumo, data e, quando presente, imagem; a reportagem completa é aberta no site do jornal.

## Executar

```sh
flutter pub get
flutter run
```

Para gerar a versão web:

```sh
flutter build web
```
