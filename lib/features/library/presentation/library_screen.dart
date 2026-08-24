import 'package:flutter/material.dart';
import 'package:playtick/l10n/app_localizations.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Center(child: Text(appLoc.libraryTitle));
  }
}
