
import 'package:flutter/material.dart';

const Color mapaLaranja = Color(0xFFFF6538);

class WorldMapPainter extends StatelessWidget {
  final String regiaoSelecionada;
  final ValueChanged<String> aoSelecionar;

  const WorldMapPainter({
    super.key,
    required this.regiaoSelecionada,
    required this.aoSelecionar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final largura = constraints.maxWidth;
        final altura = constraints.maxHeight;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (detalhes) {
            final x = detalhes.localPosition.dx / largura;
            final y = detalhes.localPosition.dy / altura;

            // Áreas aproximadas para selecionar cada região.
            if (x < 0.36 && y > 0.20 && y < 0.58) {
              aoSelecionar('Américas');
            } else if (x >= 0.36 &&
                x < 0.56 &&
                y > 0.18 &&
                y < 0.39) {
              aoSelecionar('Europa');
            } else if (x >= 0.39 &&
                x < 0.61 &&
                y >= 0.39 &&
                y < 0.76) {
              aoSelecionar('África');
            } else if (x >= 0.56 && y > 0.18 && y < 0.58) {
              aoSelecionar('Ásia-Pacífico');
            } else if (x >= 0.61 && y >= 0.58) {
              aoSelecionar('Ásia-Pacífico');
            }
          },
          child: CustomPaint(
            size: Size(largura, altura),
            painter: ContinentesPainter(
              regiaoSelecionada: regiaoSelecionada,
            ),
          ),
        );
      },
    );
  }
}

class ContinentesPainter extends CustomPainter {
  final String regiaoSelecionada;

  ContinentesPainter({required this.regiaoSelecionada});

  final Color azul = const Color(0xFF4C91FF);
  final Color verde = const Color(0xFF45D6B0);
  final Color amarelo = const Color(0xFFFFBD45);
  final Color roxo = const Color(0xFF8C78F4);
  final Color rosa = const Color(0xFFEA70BB);

  @override
  void paint(Canvas canvas, Size size) {
    final escala = size.width / 300;

    canvas.save();
    canvas.scale(escala, escala);

    // Mantém as proporções do desenho dentro do espaço disponível.
    final alturaOriginal = size.height / escala;
    final deslocamentoY = (alturaOriginal - 220) / 2;
    canvas.translate(0, deslocamentoY);

    // Linhas de latitude e longitude.
    final grade = Paint()
      ..color = Colors.white.withValues(alpha: 0.055)
      ..strokeWidth = 0.7;

    for (double x = 20; x < 300; x += 38) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, 220),
        grade,
      );
    }

    for (double y = 10; y < 220; y += 38) {
      canvas.drawLine(
        Offset(0, y),
        Offset(300, y),
        grade,
      );
    }

    // América do Norte.
    final americaNorte = Path()
      ..moveTo(12, 43)
      ..quadraticBezierTo(42, 22, 81, 34)
      ..lineTo(98, 42)
      ..lineTo(88, 55)
      ..lineTo(81, 66)
      ..lineTo(68, 79)
      ..lineTo(70, 95)
      ..lineTo(58, 102)
      ..lineTo(48, 91)
      ..lineTo(37, 81)
      ..lineTo(30, 66)
      ..lineTo(19, 57)
      ..close();

    // América do Sul.
    final americaSul = Path()
      ..moveTo(80, 111)
      ..quadraticBezierTo(110, 103, 117, 125)
      ..lineTo(110, 144)
      ..lineTo(104, 167)
      ..lineTo(91, 187)
      ..lineTo(84, 164)
      ..lineTo(79, 140)
      ..close();

    // Europa.
    final europa = Path()
      ..moveTo(128, 42)
      ..quadraticBezierTo(147, 31, 164, 42)
      ..lineTo(159, 54)
      ..lineTo(148, 61)
      ..lineTo(132, 58)
      ..close();

    // África.
    final africa = Path()
      ..moveTo(134, 81)
      ..quadraticBezierTo(161, 69, 181, 88)
      ..lineTo(189, 107)
      ..lineTo(180, 136)
      ..lineTo(166, 164)
      ..quadraticBezierTo(157, 176, 150, 157)
      ..lineTo(142, 129)
      ..lineTo(132, 105)
      ..close();

    // Ásia e Oceania representadas em conjunto.
    final asia = Path()
      ..moveTo(174, 47)
      ..quadraticBezierTo(214, 30, 278, 48)
      ..lineTo(286, 59)
      ..lineTo(271, 72)
      ..lineTo(257, 83)
      ..lineTo(240, 99)
      ..lineTo(224, 95)
      ..lineTo(207, 81)
      ..lineTo(190, 74)
      ..close();

    final oceania = Path()
      ..moveTo(239, 139)
      ..quadraticBezierTo(260, 129, 279, 140)
      ..lineTo(284, 155)
      ..lineTo(272, 164)
      ..lineTo(250, 162)
      ..lineTo(241, 153)
      ..close();

    final pequenaIlha = Path()
      ..moveTo(103, 28)
      ..quadraticBezierTo(112, 22, 121, 28)
      ..lineTo(116, 37)
      ..lineTo(109, 39)
      ..close();

    _desenharRegiao(
      canvas,
      americaNorte,
      azul,
      regiaoSelecionada == 'Américas',
    );
    _desenharRegiao(
      canvas,
      americaSul,
      verde,
      regiaoSelecionada == 'Oriente Médio',
    );
    _desenharRegiao(
      canvas,
      europa,
      mapaLaranja,
      regiaoSelecionada == 'Europa',
    );
    _desenharRegiao(
      canvas,
      africa,
      amarelo,
      regiaoSelecionada == 'África',
    );
    _desenharRegiao(
      canvas,
      asia,
      roxo,
      regiaoSelecionada == 'Ásia-Pacífico',
    );
    _desenharRegiao(
      canvas,
      oceania,
      rosa,
      regiaoSelecionada == 'Ásia-Pacífico',
    );
    _desenharRegiao(
      canvas,
      pequenaIlha,
      azul,
      false,
    );

    _texto(canvas, 'América\\ndo Norte', 34, 58, 8);
    _texto(canvas, 'América\\ndo Sul', 83, 130, 8);
    _texto(canvas, 'Europa', 137, 44, 8);
    _texto(canvas, 'África', 147, 111, 9);
    _texto(canvas, 'Ásia', 218, 61, 9);
    _texto(canvas, 'Oceania', 246, 145, 8);

    canvas.restore();
  }

  void _desenharRegiao(
    Canvas canvas,
    Path caminho,
    Color cor,
    bool selecionada,
  ) {
    if (selecionada) {
      final brilho = Paint()
        ..color = cor.withValues(alpha: 0.60)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      canvas.drawPath(caminho, brilho);
    }

    final preenchimento = Paint()
      ..color = cor
      ..style = PaintingStyle.fill;

    canvas.drawPath(caminho, preenchimento);

    final contorno = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = selecionada ? 2.0 : 1.4;

    canvas.drawPath(caminho, contorno);
  }

  void _texto(
    Canvas canvas,
    String texto,
    double x,
    double y,
    double tamanho,
  ) {
    final linhas = texto.split('\\n');

    for (int i = 0; i < linhas.length; i++) {
      final textoPainter = TextPainter(
        text: TextSpan(
          text: linhas[i],
          style: TextStyle(
            color: const Color(0xFF071B2D),
            fontSize: tamanho,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textoPainter.layout();
      textoPainter.paint(
        canvas,
        Offset(
          x - textoPainter.width / 2,
          y + (i * (tamanho + 1)),
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant ContinentesPainter oldDelegate) {
    return oldDelegate.regiaoSelecionada != regiaoSelecionada;
  }
}

class GradeMapaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final tinta = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        tinta,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GradeMapaPainter oldDelegate) => false;
}