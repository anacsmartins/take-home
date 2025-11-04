import '../entities/alias_entity.dart';

abstract class AliasRepository {
  Future<AliasEntity> shortenUrl(String url);
}
