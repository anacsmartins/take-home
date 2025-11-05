import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:url_shortener/domain/entities/alias_entity.dart';
import 'package:url_shortener/domain/usecases/shorten_url_usecase.dart';
import 'package:url_shortener/presentation/cubit/shortener_state.dart';

@injectable
class ShortenerCubit extends Cubit<ShortenerState> {
  ShortenerCubit(this.usecase) : super(const ShortenerInitial());
  final ShortenUrlUseCase usecase;
  final List<AliasEntity> _items = [];
  Future<void> shorten(String url) async {
    emit(ShortenerLoading(_items));
    try {
      final entity = await usecase(url);
      _items.insert(0, entity);
      emit(ShortenerSuccess(List.unmodifiable(_items)));
    } catch (e) {
      emit(ShortenerError(e.toString(), _items));
    }
  }
}
