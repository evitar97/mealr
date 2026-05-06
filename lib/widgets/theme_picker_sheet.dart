import 'package:flutter/cupertino.dart';

import '../app/app_state.dart';
import '../app/app_strings.dart';
import '../theme/mealweight_theme.dart';
import 'glass_surface.dart';

void showThemePickerSheet(BuildContext context) {
  showCupertinoModalPopup<void>(
    context: context,
    barrierColor: const Color(0x99000000),
    builder: (context) => const ThemePickerSheet(),
  );
}

class ThemePickerSheet extends StatelessWidget {
  const ThemePickerSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.palette;
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: GlassSurface(
                constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight - 20,
                ),
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                radius: 26,
                tint: p.card,
                opacity: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx(context, 'Téma választása'),
                      style: TextStyle(
                        color: p.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 2.3,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        for (final theme in themeOptions)
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              state.selectTheme(theme);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.dark.card,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.id == state.theme.id
                                      ? theme.dark.accent
                                      : p.border,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: theme.dark.accent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      theme.name,
                                      style: TextStyle(
                                        color: theme.dark.text,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    theme.isFree
                                        ? CupertinoIcons.check_mark_circled
                                        : CupertinoIcons.lock,
                                    size: 16,
                                    color: theme.dark.accent,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
