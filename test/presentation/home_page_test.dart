import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:your_app_name/domain/entities/alias_entity.dart';
import 'package:your_app_name/domain/usecases/shorten_url_usecase.dart';
import 'package:your_app_name/presentation/cubit/shortener_cubit.dart';
import 'package:your_app_name/presentation/pages/home_page.dart';

class MockShortenUrlUseCase extends Mock implements ShortenUrlUseCase {}

void main() {
  late MockShortenUrlUseCase mockUsecase;
  late ShortenerCubit cubit;

  const inputUrl = 'https://flutter.dev';

  setUp(() {
    mockUsecase = MockShortenUrlUseCase();
    cubit = ShortenerCubit(mockUsecase);
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

  testWidgets('should complete full flow: type -> tap -> success render list',
      (WidgetTester tester) async {
    when(() => mockUsecase(inputUrl)).thenAnswer((_) async {
      return AliasEntity(
        alias: 'flutter.dev',
        originalUrl: inputUrl,
        shortUrl: 'https://short/flutter.dev',
      );
    });

    await pumpHomePage(tester);

    final input = find.byKey(const Key('kInputUrl'));
    final button = find.byKey(const Key('kButtonShorten'));

    expect(input, findsOneWidget);
    expect(button, findsOneWidget);

    await tester.enterText(input, inputUrl);
    await tester.tap(button);
    await tester.pump(); // resolve cubit loading
    await tester.pump(); // resolve success state render

    final list = find.byKey(const Key('kListShortened'));
    expect(list, findsOneWidget);

    expect(find.text('https://short/flutter.dev'), findsOneWidget);
    expect(find.text(inputUrl), findsOneWidget);

    verify(() => mockUsecase(inputUrl)).called(1);
  });
}
