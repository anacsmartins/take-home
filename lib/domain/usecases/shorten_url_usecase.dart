import 'package:injectable/injectable.dart';

import 'package:url_shortener/domain/entities/alias_entity.dart';
import 'package:url_shortener/domain/repositories/alias_repository.dart';

@lazySingleton
class ShortenUrlUseCase {
  final AliasRepository repository;
  const ShortenUrlUseCase(this.repository);

  Future<AliasEntity> call(String url) {
    return repository.shortenUrl(url);
  }
}
