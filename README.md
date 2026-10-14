<<<<<<< HEAD
# 🌎 The New York Times — World News Map
# 🌎 The New York Times

Aplicativo mobile desenvolvido com Flutter e Dart que permite consultar notícias internacionais do The New York Times, organizadas por regiões do mundo. A aplicação utiliza feeds RSS para obter as notícias e processa os dados em XML para apresentá-los de forma organizada ao usuário.

## 🎯 Objetivo

Desenvolver um aplicativo de notícias que facilite o acesso a conteúdos internacionais, permitindo que o usuário selecione uma região do mundo e visualize as notícias correspondentes.

## 🚀 Tecnologias utilizadas

- **Flutter:** desenvolvimento da interface mobile.
- **Dart:** linguagem de programação.
- **RSS:** obtenção das notícias.
- **XML:** formato dos dados recebidos.
- **HTTP:** realização de requisições para os feeds RSS.
- **Git e GitHub:** versionamento e armazenamento do código-fonte.

## 📰 Regiões disponíveis

O aplicativo utiliza feeds RSS do The New York Times para consultar notícias das seguintes regiões:

- África
- Américas
- Ásia-Pacífico
- Europa
- Oriente Médio
- Mundo

## ⚙️ Funcionamento

O funcionamento da aplicação ocorre pelas seguintes etapas:

1. O usuário seleciona uma região do mundo.
2. O aplicativo identifica o feed RSS correspondente.
3. Uma requisição HTTP busca os dados na internet.
4. O conteúdo XML é interpretado pela aplicação.
5. As informações são organizadas em objetos Dart.
6. As notícias são apresentadas na interface do aplicativo.

## 📦 Estrutura dos dados

As notícias são representadas por objetos que podem conter as seguintes informações:

- **Título:** título da notícia.
- **Descrição:** resumo do conteúdo.
- **URL:** endereço da notícia original.
- **GUID:** identificador da notícia.
- **Data de publicação:** data em que a notícia foi publicada, quando disponível.

## 🛠️ Como executar o projeto

### Pré-requisitos

- Flutter SDK instalado.
- Dart SDK compatível com a versão do Flutter.
- Visual Studio Code ou outra IDE compatível.
- Emulador Android ou dispositivo conectado.

### Instalação

1. Clone o repositório:

   ```bash
   git clone https://github.com/karine53/The-New-York-Times.git
   ```

2. Entre na pasta do projeto Flutter:

   ```bash
   cd The-New-York-Times/dsdm
   ```

3. Instale as dependências:

   ```bash
   flutter pub get
   ```

4. Execute o aplicativo:

   ```bash
   flutter run
   ```

## 🌐 Fonte das notícias

As notícias são obtidas por meio dos feeds RSS disponibilizados pelo The New York Times.

Site oficial: https://www.nytimes.com/

Feeds RSS: https://www.nytimes.com/rss

## 👩‍💻 Desenvolvimento

Projeto acadêmico desenvolvido como atividade de programação mobile, com o objetivo de aplicar conhecimentos de Flutter, Dart, requisições HTTP e processamento de XML.

## 📄 Licença

Projeto desenvolvido para fins educacionais.
