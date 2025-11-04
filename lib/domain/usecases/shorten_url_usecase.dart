import 'package:injectable/injectable.dart';

import '../entities/alias_entity.dart';
import '../repositories/alias_repository.dart';

@lazySingleton
class ShortenUrlUseCase {
  final AliasRepository repository;
  const ShortenUrlUseCase(this.repository);

  Future<AliasEntity> call(String url) {
    return repository.shortenUrl(url);
  }
}
