import 'package:url_shortener/domain/entities/alias_entity.dart';

abstract class ShortenerState {
  const ShortenerState();
}

class ShortenerInitial extends ShortenerState {
  const ShortenerInitial();
}

class ShortenerLoading extends ShortenerState {
  final List<AliasEntity> list;
  const ShortenerLoading(this.list);
}

class ShortenerSuccess extends ShortenerState {
  final List<AliasEntity> list;
  const ShortenerSuccess(this.list);
}

class ShortenerError extends ShortenerState {
  final String message;
  final List<AliasEntity> list;
  const ShortenerError(this.message, this.list);
}
