import 'package:playtick/features/library/domain/library_exception.dart';
import 'package:playtick/l10n/app_localizations.dart';

extension LibraryExceptionExtension on Exception {
  String localizeLibraryError(AppLocalizations appLoc) {
    return switch (this) {
      DuplicateGameException() => appLoc.gameAlreadyInLibrary,
      GameNotFoundException() => appLoc.gameNotFoundInLibrary,
      InvalidPlaySessionException() => appLoc.invalidPlaySessionException,
      _ => appLoc.somethingWentWrong,
    };
  }
}
