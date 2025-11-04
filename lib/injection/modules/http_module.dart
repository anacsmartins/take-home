import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@module
abstract class HttpModule {
  @lazySingleton
  http.Client client() => http.Client();
}
