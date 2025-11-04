import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/shorten_url_usecase.dart';
import 'shortener_state.dart';

@injectable
class ShortenerCubit extends Cubit<ShortenerState> {
  final ShortenUrlUseCase usecase;

  ShortenerCubit(this.usecase) : super(ShortenerInitial());

  Future<void> shorten(String url) async {
    emit(ShortenerLoading());
    try {
      final entity = await usecase(url);

      final current = state;
      if (current is ShortenerSuccess) {
        final updated = [...current.list, entity];
        emit(ShortenerSuccess(updated));
      } else {
        emit(ShortenerSuccess([entity]));
      }
    } catch (e) {
      emit(ShortenerError(e.toString()));
    }
  }
}
