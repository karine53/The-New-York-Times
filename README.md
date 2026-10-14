# 🌎 The New York Times — World News Map

Aplicativo mobile desenvolvido em Flutter para explorar notícias internacionais por meio de um mapa-múndi interativo. O projeto utiliza os feeds RSS do **The New York Times** para carregar notícias de diferentes regiões do mundo.

## 📌 Sobre o projeto

O World News Map tem como objetivo facilitar o acesso a notícias internacionais, permitindo que o usuário selecione uma região do mundo e visualize as notícias relacionadas a ela.

A interface possui um mapa estilizado e colorido, opções para selecionar regiões, uma área para exibição das notícias e uma ferramenta de busca por títulos.

As notícias são obtidas diretamente dos feeds RSS do New York Times, permitindo que o aplicativo apresente conteúdos disponibilizados pelo veículo.

## 🎯 Objetivos

* Facilitar a exploração de notícias internacionais.
* Organizar as notícias por regiões geográficas.
* Utilizar uma interface visual e interativa.
* Consumir e interpretar dados disponibilizados em XML.
* Desenvolver uma aplicação mobile utilizando Flutter e Dart.

## ✨ Funcionalidades

* **Mapa-múndi interativo:** permite selecionar regiões para consultar notícias.
* **Seleção de regiões:** acesso às notícias da África, Américas, Ásia-Pacífico, Europa, Oriente Médio e Mundo.
* **Carregamento de notícias:** consulta aos feeds RSS correspondentes à região selecionada.
* **Exibição de notícias:** apresentação dos títulos e das descrições disponíveis.
* **Busca:** pesquisa de notícias pelo título entre os resultados carregados.
* **Atualização:** possibilidade de atualizar as notícias.
* **Tratamento de erros:** exibição de mensagens quando não é possível carregar o conteúdo.

## 📰 Fonte dos dados

O aplicativo utiliza os feeds RSS do The New York Times. O RSS disponibiliza conteúdos atualizados em XML, formato que organiza as informações em elementos e atributos.

O aplicativo utiliza o pacote `http` para realizar as requisições e o pacote `xml` para interpretar os dados recebidos.

### Feeds RSS utilizados

| Região        | Endpoint                                                                        |
| ------------- | ------------------------------------------------------------------------------- |
| África        | [Africa.xml](https://rss.nytimes.com/services/xml/rss/nyt/Africa.xml)           |
| Américas      | [Americas.xml](https://rss.nytimes.com/services/xml/rss/nyt/Americas.xml)       |
| Ásia-Pacífico | [AsiaPacific.xml](https://rss.nytimes.com/services/xml/rss/nyt/AsiaPacific.xml) |
| Europa        | [Europe.xml](https://rss.nytimes.com/services/xml/rss/nyt/Europe.xml)           |
| Oriente Médio | [MiddleEast.xml](https://rss.nytimes.com/services/xml/rss/nyt/MiddleEast.xml)   |
| Mundo         | [World.xml](https://rss.nytimes.com/services/xml/rss/nyt/World.xml)             |

### Dados extraídos

O aplicativo interpreta os seguintes campos dos itens RSS:

* `title`: título da notícia.
* `description`: descrição ou resumo disponível.
* `link`: endereço da notícia original.
* `guid`: identificador do item.
* `pubDate`: data de publicação, quando disponível e interpretável.

## 🛠️ Tecnologias utilizadas

* **Flutter:** desenvolvimento da interface mobile.
* **Dart:** linguagem de programação utilizada no aplicativo.
* **HTTP:** realização de requisições aos feeds RSS.
* **XML:** interpretação dos dados recebidos.
* **URL Launcher:** abertura de links externos no navegador.

## 📂 Estrutura do projeto

```text
The-New-York-Times/
├── README.md
└── dsdm/
    ├── pubspec.yaml
    └── lib/
        ├── main.dart
        ├── data/
        │   └── regions.dart
        ├── models/
        │   ├── news.dart
        │   └── region_feed.dart
        ├── screens/
        │   ├── home_screen.dart
        │   ├── news_screen.dart
        │   └── news_detail_screen.dart
        ├── services/
        │   └── rss_service.dart
        └── widgets/
            ├── news_card.dart
            ├── region_card.dart
            └── world_map_painter.dart
```

### Organização dos arquivos

* `main.dart`: inicialização do aplicativo.
* `data/regions.dart`: definição das regiões e dos respectivos endpoints RSS.
* `models/news.dart`: modelo de dados das notícias.
* `models/region_feed.dart`: modelo de dados dos feeds regionais.
* `services/rss_service.dart`: requisição e interpretação dos dados RSS.
* `screens/home_screen.dart`: tela principal e seleção das regiões.
* `widgets/world_map_painter.dart`: desenho e interação com o mapa-múndi.
* `screens/news_screen.dart` e `screens/news_detail_screen.dart`: arquivos destinados às telas de notícias e detalhes.
* `widgets/news_card.dart` e `widgets/region_card.dart`: componentes reutilizáveis da interface.

## ⚙️ Como executar o projeto

### Pré-requisitos

* Flutter instalado e configurado.
* Dart disponível por meio do Flutter SDK.
* Visual Studio Code ou outra IDE compatível.
* Emulador ou dispositivo para executar o aplicativo.
* Conexão com a internet para consultar os feeds RSS.

### 1. Clonar o repositório

```bash
git clone https://github.com/karine53/The-New-York-Times.git
```

### 2. Acessar a pasta do aplicativo

```bash
cd The-New-York-Times/dsdm
```

### 3. Instalar as dependências

```bash
flutter pub get
```

### 4. Executar o aplicativo

```bash
flutter run
```

## 🔄 Funcionamento da aplicação

O funcionamento segue estas etapas:

1. O usuário seleciona uma região no mapa ou nos botões disponíveis.
2. O aplicativo identifica o endpoint RSS correspondente.
3. O serviço `RssService` realiza uma requisição HTTP.
4. A resposta XML é interpretada para extrair os dados das notícias.
5. Os dados são organizados em objetos do modelo `News`.
6. A interface apresenta as notícias recebidas.

## 📚 Aprendizados

O desenvolvimento do projeto envolve conceitos de desenvolvimento mobile com Flutter, consumo de fontes externas de dados, requisições HTTP, interpretação de XML, organização do código em modelos e serviços e criação de interfaces interativas.

## 👥 Equipe

Projeto acadêmico desenvolvido como atividade de estudo e prática de desenvolvimento de aplicações mobile.

## 🔗 Repositório

[The New York Times — GitHub](https://github.com/karine53/The-New-York-Times)

## 📄 Fonte das notícias

O conteúdo jornalístico é disponibilizado pelo [The New York Times](https://www.nytimes.com/). Os links das notícias direcionam para suas respectivas páginas originais.
