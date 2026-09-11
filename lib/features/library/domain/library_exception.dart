final class DuplicateGameException implements Exception {
  const DuplicateGameException();
}

final class GameNotFoundException implements Exception {
  const GameNotFoundException();
}

final class IgdbCredentialsNotConfiguredException implements Exception {
  const IgdbCredentialsNotConfiguredException();
}

final class IgdbTokenFetchException implements Exception {
  const IgdbTokenFetchException();
}

final class IgdbSearchException implements Exception {
  const IgdbSearchException();
}

final class InvalidPlaySessionException implements Exception {
  const InvalidPlaySessionException();
}

final class PlaySessionNotFoundException implements Exception {
  const PlaySessionNotFoundException();
}

final class InvalidActivePlaySessionException implements Exception {
  const InvalidActivePlaySessionException();
}

final class DuplicateActivePlaySessionException implements Exception {
  const DuplicateActivePlaySessionException();
}

final class ActivePlaySessionNotFoundException implements Exception {
  const ActivePlaySessionNotFoundException();
}
