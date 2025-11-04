import 'package:injectable/injectable.dart';

import '../../domain/entities/alias_entity.dart';
import '../../domain/repositories/alias_repository.dart';
import '../datasources/url_shortener_api.dart';

@LazySingleton(as: AliasRepository)
class AliasRepositoryImpl implements AliasRepository {
  final UrlShortenerApi api;
  const AliasRepositoryImpl(this.api);

  @override
  Future<AliasEntity> shortenUrl(String url) async {
    final res = await api.shorten(url);
    return res.toEntity();
  }
}
