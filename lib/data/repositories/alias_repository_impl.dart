import 'package:injectable/injectable.dart';

import 'package:url_shortener/domain/entities/alias_entity.dart';
import 'package:url_shortener/domain/repositories/alias_repository.dart';
import 'package:url_shortener/data/datasources/url_shortener_api.dart';

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
