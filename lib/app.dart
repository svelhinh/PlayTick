import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playtick/app_router.dart';
import 'package:playtick/l10n/app_localizations.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app.g.dart';

@riverpod
String appTitle(Ref ref) => "PlayTick";

class PlayTick extends ConsumerWidget {
  const PlayTick({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = ref.watch(appTitleProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      localizationsDelegates: [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      title: title,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
