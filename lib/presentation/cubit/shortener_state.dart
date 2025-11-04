import 'package:url_shortener/domain/entities/alias_entity.dart';

sealed class ShortenerState {}

class ShortenerInitial extends ShortenerState {}

class ShortenerLoading extends ShortenerState {}

class ShortenerSuccess extends ShortenerState {
  final List<AliasEntity> list;
  ShortenerSuccess(this.list);
}

class ShortenerError extends ShortenerState {
  final String message;
  ShortenerError(this.message);
}
