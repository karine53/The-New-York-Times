import 'package:flutter/material.dart';

Color regionColor(String name) {
  switch (name) {
    case 'África':
      return const Color(0xFFFFBD45);
    case 'Américas':
      return const Color(0xFF4C91FF);
    case 'Ásia-Pacífico':
      return const Color(0xFF8C78F4);
    case 'Europa':
      return const Color(0xFFFF6538);
    case 'Oriente Médio':
      return const Color(0xFF45D6B0);
    default:
      return const Color(0xFFEA70BB);
  }
}

