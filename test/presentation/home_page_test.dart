import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/domain/entities/alias_entity.dart';
import '../../lib/domain/usecases/shorten_url_usecase.dart';
import '../../lib/presentation/cubit/shortener_cubit.dart';
import '../../lib/presentation/pages/home_page.dart';

class MockShortenUrlUseCase extends Mock implements ShortenUrlUseCase {}

void main() {
  late MockShortenUrlUseCase mockUsecase;
  late ShortenerCubit cubit;

  const inputUrl = 'https://flutter.dev';

  setUp(() {
    mockUsecase = MockShortenUrlUseCase();
    cubit = ShortenerCubit(mockUsecase);
    registerFallbackValue(inputUrl);
  });

  Future<void> pumpHomePage(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: const HomePage(),
        ),
      ),
    );
  }

  testWidgets('full flow: type + tap + success render (scoped by keys)', (tester) async {
    when(() => mockUsecase.call(inputUrl)).thenAnswer((_) async {
      return const AliasEntity(
        alias: 'flutter.dev',
        originalUrl: inputUrl,
        shortUrl: 'https://short/flutter.dev',
      );
    });

    await pumpHomePage(tester);

    // Interação usando KEYS (evita ambiguidade com EditableText)
    await tester.enterText(find.byKey(const Key('kInputUrl')), inputUrl);
    await tester.tap(find.byKey(const Key('kButtonShorten')));

    // Aguarda animações/emissões do Cubit e rebuilds
    await tester.pump();          // resolve loading
    await tester.pumpAndSettle(); // espera Success + List renderizada

    // Lista presente
    final listFinder = find.byKey(const Key('kListShortened'));
    expect(listFinder, findsOneWidget);

    // Item 0 presente (usando a key do item)
    final tile0 = find.byKey(const Key('kShortItem-0'));
    expect(tile0, findsOneWidget);

    // Valida textos **escopados ao item** (não global)
    expect(
      find.descendant(of: tile0, matching: find.text('https://short/flutter.dev')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: tile0, matching: find.text(inputUrl)),
      findsOneWidget,
    );

    verify(() => mockUsecase.call(inputUrl)).called(1);
  });
}
