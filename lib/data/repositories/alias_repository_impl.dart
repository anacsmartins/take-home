import '../../domain/entities/alias_entity.dart';
import '../../domain/repositories/alias_repository.dart';
import '../datasources/url_shortener_api.dart';

class AliasRepositoryImpl implements AliasRepository {
  final UrlShortenerApi api;

  AliasRepositoryImpl(this.api);

  @override
  Future<AliasEntity> shortenUrl(String url) async {
    final res = await api.shorten(url);
    return res.toEntity();
  }
}
