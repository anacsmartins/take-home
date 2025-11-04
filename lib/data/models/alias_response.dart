import 'package:url_shortener/domain/entities/alias_entity.dart';

class AliasResponse {
  final String alias;
  final String originalUrl;
  final String shortUrl;

  const AliasResponse({
    required this.alias,
    required this.originalUrl,
    required this.shortUrl,
  });

  factory AliasResponse.fromJson(Map<String, dynamic> json) {
    final links = json['_links'] as Map<String, dynamic>? ?? const {};
    return AliasResponse(
      alias: json['alias'] as String,
      originalUrl: (links['self'] ?? '') as String,
      shortUrl: (links['short'] ?? '') as String,
    );
  }

  AliasEntity toEntity() =>
      AliasEntity(alias: alias, originalUrl: originalUrl, shortUrl: shortUrl);
}
