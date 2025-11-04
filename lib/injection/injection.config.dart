// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:url_shortener/data/datasources/url_shortener_api.dart' as _i721;
import 'package:url_shortener/data/repositories/alias_repository_impl.dart'
    as _i173;
import 'package:url_shortener/domain/repositories/alias_repository.dart'
    as _i572;
import 'package:url_shortener/domain/usecases/shorten_url_usecase.dart'
    as _i539;
import 'package:url_shortener/injection/modules/http_module.dart' as _i457;
import 'package:url_shortener/presentation/cubit/shortener_cubit.dart' as _i380;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final httpModule = _$HttpModule();
    gh.lazySingleton<_i519.Client>(() => httpModule.client());
    gh.lazySingleton<_i721.UrlShortenerApi>(
      () => _i721.UrlShortenerApi(gh<_i519.Client>()),
    );
    gh.lazySingleton<_i572.AliasRepository>(
      () => _i173.AliasRepositoryImpl(gh<_i721.UrlShortenerApi>()),
    );
    gh.lazySingleton<_i539.ShortenUrlUseCase>(
      () => _i539.ShortenUrlUseCase(gh<_i572.AliasRepository>()),
    );
    gh.factory<_i380.ShortenerCubit>(
      () => _i380.ShortenerCubit(gh<_i539.ShortenUrlUseCase>()),
    );
    return this;
  }
}

class _$HttpModule extends _i457.HttpModule {}
