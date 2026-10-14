import 'package:flutter/material.dart';

import '../app_controller.dart';

const _accent = Color(0xFFFF6538);

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
          children: [
            Text(
              'Configurações',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              'Personalize sua experiência de leitura.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 19),
            _sectionLabel(context, 'PREFERÊNCIAS'),
            _settingsCard(context, [
              _switchTile(
                context,
                icon: controller.darkMode ? Icons.dark_mode : Icons.light_mode,
                title: 'Tema escuro',
                subtitle: controller.darkMode ? 'Ativado' : 'Desativado',
                value: controller.darkMode,
                onChanged: controller.setDarkMode,
              ),
              _divider(context),
              _switchTile(
                context,
                icon: Icons.notifications_none,
                title: 'Notificações',
                subtitle: 'Alertas de notícias importantes',
                value: controller.notificationsEnabled,
                onChanged: controller.setNotifications,
              ),
            ]),
            const SizedBox(height: 15),
            _sectionLabel(context, 'ACESSIBILIDADE'),
            _settingsCard(context, [
              _switchTile(
                context,
                icon: Icons.text_fields,
                title: 'Texto ampliado',
                subtitle: controller.largeText ? 'Tamanho maior' : 'Tamanho padrão',
                value: controller.largeText,
                onChanged: controller.setLargeText,
              ),
              _divider(context),
              _switchTile(
                context,
                icon: Icons.motion_photos_off_outlined,
                title: 'Reduzir animações',
                subtitle: 'Usar transições mais discretas',
                value: controller.reduceMotion,
                onChanged: controller.setReduceMotion,
              ),
            ]),
            const SizedBox(height: 15),
            _sectionLabel(context, 'DADOS E SOBRE'),
            _settingsCard(context, [
              ListTile(
                leading: const Icon(Icons.cached),
                title: const Text('Atualizar notícias'),
                subtitle: const Text('Limpar o cache dos feeds'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await controller.clearCachedNews();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cache de notícias limpo.')),
                    );
                  }
                },
              ),
              _divider(context),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Sobre o World News Map'),
                subtitle: const Text('Notícias fornecidas pelos feeds RSS do The New York Times'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'World News Map',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'As notícias e marcas pertencem ao The New York Times. O app usa feeds RSS públicos e não é afiliado ao jornal.',
                ),
              ),
            ]),
            const SizedBox(height: 18),
            const Center(
              child: Text(
                'WORLD NEWS MAP  ·  1.0.0',
                style: TextStyle(
                  color: _accent,
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(left: 3, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            color: _accent,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.7,
          ),
        ),
      );

  Widget _settingsCard(BuildContext context, List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      );

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      SwitchListTile(
        secondary: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        activeThumbColor: _accent,
        onChanged: onChanged,
      );

  Widget _divider(BuildContext context) => Divider(
        height: 1,
        indent: 58,
        color: Theme.of(context).dividerColor,
      );
}
